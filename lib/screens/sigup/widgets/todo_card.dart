// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_todo_app/services/todo_list/todo_list_bloc.dart';

// class TodoCard extends StatelessWidget {
//   const TodoCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<TodoListBloc, TodoListState>(
//         builder: (context, state) {
//           if (state is ToDoListLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is ToDoListLoaded) {
//             return ListView.builder(
//               itemBuilder: (context, index) {
//                 final task = state.tasks[index];
//                 return ListTile(
//                   title: Text(task.todo),
//                   trailing: Icon(
//                     task.completed
//                         ? Icons.check_circle
//                         : Icons.check_circle_outlined,
//                   ),
//                 );
//               },
//             );
//           } else if (state is ToDoListError) {
//             return Center(child: Text(state.message));
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }
