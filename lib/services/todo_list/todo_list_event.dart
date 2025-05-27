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

class AddTask extends TodoListEvent {
  final Task task;
  AddTask(this.task);
}

class DeleteTask extends TodoListEvent {
  final int taskId;
  DeleteTask(this.taskId);
}

class EditTask extends TodoListEvent {
  final Task task;
  EditTask(this.task);
}
