import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/screens/sigup/todo_list_screen.dart';
import 'package:my_todo_app/services/todo_list/todo_list_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => TodoListBloc()..add(LoadTasks()),
        child: SignUpScreen(),
      ),
    );
  }
}
