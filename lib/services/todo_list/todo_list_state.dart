part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListState {}

final class TodoListInitial extends TodoListState {}

class ToDoListLoading extends TodoListState {}

class ToDoListLoaded extends TodoListState {
  final List<Task> tasks;
  ToDoListLoaded(this.tasks);
}

class ToDoListError extends TodoListState {
  final String message;
  ToDoListError(this.message);
}
