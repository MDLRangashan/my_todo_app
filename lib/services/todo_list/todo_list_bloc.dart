import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListInitial()) {
    on<TodoListEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadTasks>((event, emit) async {
      emit(ToDoListLoading());
      try {
        // First try to load from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final cachedTasksJson = prefs.getStringList('tasks');

        if (cachedTasksJson != null && cachedTasksJson.isNotEmpty) {
          final tasks =
              cachedTasksJson
                  .map((taskJson) => Task.fromJson(json.decode(taskJson)))
                  .toList();
          emit(ToDoListLoaded(tasks));
          return;
        }

        // If no cached data, fetch from API
        final String _apiUrl = 'https://dummyjson.com/todos';
        try {
          final response = await http.get(Uri.parse(_apiUrl));
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['todos'] != null && data['todos'] is List) {
              final tasks = List<Task>.from(
                data['todos'].map((e) => Task.fromJson(e)),
              );
              // Cache the fetched tasks
              await _saveTasksToPrefs(tasks);
              emit(ToDoListLoaded(tasks));
            }
          } else {
            emit(ToDoListError('Error getting tasks'));
          }
        } catch (e) {
          // If API call fails and we have no cached data, show error
          emit(
            ToDoListError(
              'No internet connection and no cached data available',
            ),
          );
        }
      } catch (e) {
        emit(ToDoListError('Error: ${e.toString()}'));
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
          final updatedTasks =
              currentState.tasks.map((task) {
                if (task.id == event.taskId) {
                  return Task(
                    id: task.id,
                    todo: task.todo,
                    completed: event.isCompleted,
                    userId: task.userId,
                  );
                }
                return task;
              }).toList();

          await _saveTasksToPrefs(updatedTasks);
          emit(ToDoListLoaded(updatedTasks));
        } catch (e) {
          emit(ToDoListError('Error toggling task: ${e.toString()}'));
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
