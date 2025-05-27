import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/screens/sigup/widgets/todo_card.dart';
import 'package:my_todo_app/services/todo_list/todo_list_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register Yourself",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TodoListBloc, TodoListState>(
        builder: (context, state) {
          if (state is ToDoListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ToDoListLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return CheckboxListTile(
                  title: Text(task.todo),
                  value: task.completed,
                  onChanged: (value) {
                    print("${task.todo}");
                    print("Checkbox changed - $value");
                    context.read<TodoListBloc>().add(
                      ToggleTask(task.id, value ?? false),
                    );
                  },
                );
                // return ListTile(
                //   title: Text(task.todo),
                //   // trailing: Icon(
                //   //   task.completed
                //   //       ? Icons.check_circle
                //   //       : Icons.check_circle_outlined,
                //   // ),
                //   leading: Checkbox(
                //     value: task.completed,
                //     onChanged: (bool? value) {
                //       task.completed = value ?? false;
                //       context.read<TodoListBloc>().add(
                //         UpdateTaskCompletion(task),
                //       );
                //     },
                //   ),
                // );
              },
            );
          } else if (state is ToDoListError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
