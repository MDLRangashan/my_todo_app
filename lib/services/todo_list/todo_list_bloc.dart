import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_todo_app/data/database_helper.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  TodoListBloc() : super(TodoListInitial()) {
    on<TodoListEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadTasks>((event, emit) async {
      emit(ToDoListLoading());
      try {
        // First try to load from SQLite database
        try {
          final tasks = await dbHelper.getTasks();

          if (tasks.isNotEmpty) {
            emit(ToDoListLoaded(tasks));
            return;
          }

          // If database is empty, try loading from SharedPreferences as fallback
          final prefs = await SharedPreferences.getInstance();
          final cachedTasksJson = prefs.getStringList('tasks');

          if (cachedTasksJson != null && cachedTasksJson.isNotEmpty) {
            final tasks =
                cachedTasksJson
                    .map((taskJson) => Task.fromJson(json.decode(taskJson)))
                    .toList();

            // Migrate data from SharedPreferences to SQLite
            await dbHelper.insertAll(tasks);

            emit(ToDoListLoaded(tasks));
            return;
          }

          // If no cached data, fetch from API
          final String _apiUrl = 'https://dummyjson.com/todos';
          final response = await http.get(Uri.parse(_apiUrl));

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['todos'] != null && data['todos'] is List) {
              final tasks = List<Task>.from(
                data['todos'].map((e) => Task.fromJson(e)),
              );

              // Cache in both SQLite and SharedPreferences
              await dbHelper.insertAll(tasks);
              await _saveTasksToPrefs(tasks);

              emit(ToDoListLoaded(tasks));
            }
          } else {
            emit(ToDoListError('Error getting tasks: ${response.statusCode}'));
          }
        } catch (e) {
          emit(ToDoListError('Network error: ${e.toString()}'));
        }
      } catch (e) {
        emit(ToDoListError('Error: ${e.toString()}'));
      }
    });

    on<AddTask>((event, emit) async {
      if (state is ToDoListLoaded) {
        try {
          final currentState = state as ToDoListLoaded;
          final newTask = event.task;

          // Add to database
          await dbHelper.insertTask(newTask);

          // Update state
          final updatedTasks = List<Task>.from(currentState.tasks)
            ..add(newTask);
          emit(ToDoListLoaded(updatedTasks));
        } catch (e) {
          emit(ToDoListError('Error adding task: ${e.toString()}'));
        }
      }
    });

    on<DeleteTask>((event, emit) async {
      if (state is ToDoListLoaded) {
        try {
          final currentState = state as ToDoListLoaded;

          // Delete from database
          await dbHelper.deleteTask(event.taskId);

          // Update state
          final updatedTasks =
              currentState.tasks
                  .where((task) => task.id != event.taskId)
                  .toList();

          emit(ToDoListLoaded(updatedTasks));
        } catch (e) {
          emit(ToDoListError('Error deleting task: ${e.toString()}'));
        }
      }
    });

    on<UpdateTaskCompletion>((event, emit) async {
      if (state is ToDoListLoaded) {
        try {
          final currentState = state as ToDoListLoaded;
          final updatedTasks =
              currentState.tasks.map((task) {
                if (task.id == event.task.id) {
                  return Task(
                    id: task.id,
                    todo: task.todo,
                    completed: event.task.completed,
                    userId: task.userId,
                  );
                }
                return task;
              }).toList();

          // Update in database
          await dbHelper.updateTask(event.task);

          // Also update in SharedPreferences as backup
          await _saveTasksToPrefs(updatedTasks);

          emit(ToDoListLoaded(updatedTasks));
        } catch (e) {
          emit(ToDoListError('Error updating task: ${e.toString()}'));
        }
      }
    });

    on<ToggleTask>((event, emit) async {
      if (state is ToDoListLoaded) {
        try {
          final currentState = state as ToDoListLoaded;

          // Find the task
          final task = currentState.tasks.firstWhere(
            (t) => t.id == event.taskId,
            orElse: () => throw Exception('Task not found'),
          );

          // Create updated task
          final updatedTask = Task(
            id: task.id,
            todo: task.todo,
            completed: event.isCompleted,
            userId: task.userId,
          );

          // Update in database
          await dbHelper.updateTask(updatedTask);

          // Update in state
          final updatedTasks =
              currentState.tasks.map((t) {
                if (t.id == event.taskId) {
                  return updatedTask;
                }
                return t;
              }).toList();

          // Also update in SharedPreferences as backup
          await _saveTasksToPrefs(updatedTasks);

          emit(ToDoListLoaded(updatedTasks));
        } catch (e) {
          emit(ToDoListError('Error toggling task: ${e.toString()}'));
        }
      }
    });

    on<EditTask>((event, emit) async {
      if (state is ToDoListLoaded) {
        try {
          final currentState = state as ToDoListLoaded;

          // Update in database
          await dbHelper.updateTask(event.task);

          // Update in state
          final updatedTasks =
              currentState.tasks.map((t) {
                if (t.id == event.task.id) {
                  return event.task;
                }
                return t;
              }).toList();

          // Also update in SharedPreferences as backup
          await _saveTasksToPrefs(updatedTasks);

          emit(ToDoListLoaded(updatedTasks));
        } catch (e) {
          emit(ToDoListError('Error editing task: ${e.toString()}'));
        }
      }
    });
  }

  Future<void> _saveTasksToPrefs(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }
}
