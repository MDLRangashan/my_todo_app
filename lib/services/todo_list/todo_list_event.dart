part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListEvent {}

class LoadTasks extends TodoListEvent {}

class UpdateTaskCompletion extends TodoListEvent {
  final Task task;
  UpdateTaskCompletion(this.task);
}

class ToggleTask extends TodoListEvent {
  final int taskId;
  final bool isCompleted;
  ToggleTask(this.taskId, this.isCompleted);
}
