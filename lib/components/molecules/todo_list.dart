import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final void Function(Todo) onTodoTap;
  final void Function(Todo) onTodoCompleteToggle;

  const TodoList({
    super.key,
    required this.todos,
    required this.onTodoTap,
    required this.onTodoCompleteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          title: Text(todo.title),
          subtitle: Text(todo.description),
          trailing: IconButton(
            icon: Icon(todo.isCompleted ? Icons.undo : Icons.check),
            onPressed: () => onTodoCompleteToggle(todo),
          ),
          onTap: () => onTodoTap(todo),
        );
      },
    );
  }
}
