import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/services/todo_list/todo_list_bloc.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task; // If null, we're adding a new task, otherwise editing

  const AddEditTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  late TextEditingController _todoController;
  bool _isCompleted = false;
  final int _userId = 1; // Default user ID

  @override
  void initState() {
    super.initState();
    _todoController = TextEditingController();

    // If editing existing task, populate fields
    if (widget.task != null) {
      _todoController.text = widget.task!.todo;
      _isCompleted = widget.task!.completed;
    }
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isCompleted = value ?? false;
                    });
                  },
                ),
                const Text('Completed'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                isEditing ? 'Update Task' : 'Add Task',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask() {
    final String todo = _todoController.text.trim();
    if (todo.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task cannot be empty')));
      return;
    }

    if (widget.task != null) {
      // Editing existing task
      final updatedTask = Task(
        id: widget.task!.id,
        todo: todo,
        completed: _isCompleted,
        userId: widget.task!.userId,
      );

      context.read<TodoListBloc>().add(EditTask(updatedTask));
    } else {
      // Creating new task
      // Generate a random ID (In a real app, this would be handled by the server)
      final random = Random();
      final newTask = Task(
        id: random.nextInt(10000) + 1000, // Simple random ID
        todo: todo,
        completed: _isCompleted,
        userId: _userId,
      );

      context.read<TodoListBloc>().add(AddTask(newTask));
    }

    Navigator.pop(context);
  }
}
