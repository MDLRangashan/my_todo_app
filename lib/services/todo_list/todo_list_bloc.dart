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
        final String _apiUrl = 'https://dummyjson.com/todos';
        final response = await http.get(Uri.parse(_apiUrl));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['todos'] != null && data['todos'] is List) {
            final tasks = List<Task>.from(
              data['todos'].map((e) => Task.fromJson(e)),
            );
            emit(ToDoListLoaded(tasks));
          }
        } else {
          emit(ToDoListError('Error getting tasks'));
        }
      } catch (e) {
        emit(ToDoListError('Error getting tasks ${e.toString()}'));
      }
    });

    on<UpdateTaskCompletion>((event, emit) async {
      try {
        final updatedTask = event.task;
        final prefs = await SharedPreferences.getInstance();
        final taskJson = prefs.getStringList('tasks') ?? [];

        final updateTasks =
            taskJson.map((taskJson) {
              final task = Task.fromJson(json.decode(taskJson));
              if (task.id == updatedTask.id) {
                task.completed = updatedTask.completed;
              }
              return json.encode(task.toJson());
            }).toList();

        await prefs.setStringList('tasks', updateTasks);
        add(LoadTasks());
      } catch (e) {
        emit(ToDoListError('Error updating task ${e.toString()}'));
      }
    });

    Future<void> _saveTasksToPrefs(List<Task> tasks) async {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson =
          tasks.map((task) => json.encode(task.toJson())).toList();
      await prefs.setStringList('tasks', tasksJson);
    }

    Future<void> _onToggleTask(
      ToggleTask event,
      Emitter<TodoListState> emit,
    ) async {
      if (state is ToDoListLoaded) {
        final currentTasks = (state as ToDoListLoaded).tasks;
        final updatedTasks =
            currentTasks.map((task) {
              if (task.id == event.taskId) {
                task.completed = event.isCompleted;
              }
              return task;
            }).toList();
        await _saveTasksToPrefs(updatedTasks);
        emit(ToDoListLoaded(updatedTasks));
      }
    }
  }
}
