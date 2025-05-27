import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/l10n/app_localizations.dart';
import 'package:my_todo_app/screens/add_edit_task_screen.dart';
import 'package:my_todo_app/screens/task_detail_screen.dart';
import 'package:my_todo_app/services/todo_list/todo_list_bloc.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.myTasks,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditTaskScreen()),
          );
        },
        tooltip: localizations.addNewTask, // For screen readers
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoListBloc, TodoListState>(
        builder: (context, state) {
          if (state is ToDoListLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  // Semantic label for screen readers
                  Semantics(
                    label: 'Loading tasks',
                    child: const Text('Loading...'),
                  ),
                ],
              ),
            );
          } else if (state is ToDoListLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Semantics(
                  label: localizations.noTasks,
                  child: Text(
                    localizations.noTasks,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Dismissible(
                  key: Key('task_${task.id}'),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(localizations.confirmDelete),
                          content: Text(localizations.confirmDeleteMessage),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(localizations.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(localizations.delete),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    context.read<TodoListBloc>().add(DeleteTask(task.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations.taskDeleted),
                        action: SnackBarAction(
                          label: localizations.undo,
                          onPressed: () {
                            context.read<TodoListBloc>().add(AddTask(task));
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: Semantics(
                      // Accessibility hints
                      label:
                          task.completed
                              ? '${task.todo}, ${localizations.completed}'
                              : '${task.todo}, ${localizations.pending}',
                      hint: 'Swipe left to delete, tap to view details',
                      child: ListTile(
                        title: Text(
                          task.todo,
                          style: TextStyle(
                            decoration:
                                task.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                            color: task.completed ? Colors.grey : null,
                          ),
                        ),
                        leading: ExcludeSemantics(
                          // We exclude this from semantics because we already described completion status
                          child: Checkbox(
                            value: task.completed,
                            onChanged: (value) {
                              context.read<TodoListBloc>().add(
                                ToggleTask(task.id, value ?? false),
                              );
                            },
                          ),
                        ),
                        trailing: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.chevron_right)],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => TaskDetailScreen(task: task),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is ToDoListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: state.message,
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TodoListBloc>().add(LoadTasks());
                    },
                    child: Text(localizations.retry),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
