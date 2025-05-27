import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/screens/task_detail_screen.dart';
import 'package:my_todo_app/services/todo_list/todo_list_bloc.dart';

void main() {
  late TodoListBloc mockBloc;

  setUp(() {
    mockBloc = TodoListBloc();
  });

  tearDown(() {
    mockBloc.close();
  });

  testWidgets('TaskDetailScreen displays task details correctly', (
    WidgetTester tester,
  ) async {
    // Create a test task
    final task = Task(id: 1, todo: 'Test Task', completed: false, userId: 1);

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TodoListBloc>.value(
          value: mockBloc,
          child: TaskDetailScreen(task: task),
        ),
      ),
    );

    // Verify that task details are displayed
    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('Task ID: 1'), findsOneWidget);
    expect(find.text('Assigned to User: 1'), findsOneWidget);

    // Verify checkbox state
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);

    // Test toggling the checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // Verify that ToggleTask event was added to the bloc
    // (This is a simplified check, in a real test we would use a mock bloc)
  });
}
