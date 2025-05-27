import 'app_localizations.dart';

class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs() : super('es');

  @override
  String get myTasks => 'Mis Tareas';

  @override
  String get noTasks =>
      'No hay tareas aún.\n¡Toca + para añadir una nueva tarea!';

  @override
  String get addNewTask => 'Añadir Nueva Tarea';

  @override
  String get taskDeleted => 'Tarea eliminada';

  @override
  String get undo => 'Deshacer';

  @override
  String get retry => 'Reintentar';

  @override
  String get confirmDelete => 'Confirmar';

  @override
  String get confirmDeleteMessage =>
      '¿Estás seguro de que quieres eliminar esta tarea?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get taskDetails => 'Detalles de la Tarea';

  @override
  String get status => 'Estado';

  @override
  String get completed => 'Completada';

  @override
  String get pending => 'Pendiente';

  @override
  String get taskId => 'ID de Tarea';

  @override
  String get assignedToUser => 'Asignada al Usuario';

  @override
  String get addTask => 'Añadir Tarea';

  @override
  String get editTask => 'Editar Tarea';

  @override
  String get taskLabel => 'Tarea';

  @override
  String get updateTask => 'Actualizar Tarea';

  @override
  String get taskCannotBeEmpty => 'La tarea no puede estar vacía';

  @override
  String get errorGettingTasks => 'Error al obtener tareas';

  @override
  String get networkError => 'Error de red';

  @override
  String get noInternetNoCache =>
      'Sin conexión a internet y sin datos almacenados';
}
