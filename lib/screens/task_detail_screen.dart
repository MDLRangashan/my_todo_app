import 'package:flutter/material.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/services/todo_list/todo_list_bloc.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.todo, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Checkbox(
                  value: task.completed,
                  onChanged: (bool? value) {
                    context.read<TodoListBloc>().add(
                      ToggleTask(task.id, value ?? false),
                    );
                    Navigator.pop(context);
                  },
                ),
                Text(
                  task.completed ? 'Completed' : 'Pending',
                  style: TextStyle(
                    color: task.completed ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Task ID: ${task.id}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Assigned to User: ${task.userId}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
