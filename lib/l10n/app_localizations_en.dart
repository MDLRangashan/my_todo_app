import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get myTasks => 'My Tasks';

  @override
  String get noTasks => 'No tasks yet.\nTap + to add a new task!';

  @override
  String get addNewTask => 'Add New Task';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get undo => 'Undo';

  @override
  String get retry => 'Retry';

  @override
  String get confirmDelete => 'Confirm';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this task?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get taskDetails => 'Task Details';

  @override
  String get status => 'Status';

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String get taskId => 'Task ID';

  @override
  String get assignedToUser => 'Assigned to User';

  @override
  String get addTask => 'Add Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get taskLabel => 'Task';

  @override
  String get updateTask => 'Update Task';

  @override
  String get taskCannotBeEmpty => 'Task cannot be empty';

  @override
  String get errorGettingTasks => 'Error getting tasks';

  @override
  String get networkError => 'Network error';

  @override
  String get noInternetNoCache =>
      'No internet connection and no cached data available';
}
