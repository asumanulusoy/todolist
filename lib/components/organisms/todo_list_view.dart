import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/viewmodels/home_viewmodel.dart';
import 'package:todolist/views/todo/add_edit_todo_view.dart';

class TodoListView extends StatelessWidget {
  final RxList<Todo> todos;

  const TodoListView({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (todos.isEmpty) {
        return const Center(child: Text('Todo bulunamadı.'));
      }
      return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              title: Text(
                todo.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700] ?? Colors.blue,
                ),
              ),
              subtitle: Text(todo.description.isNotEmpty
                  ? todo.description
                  : 'Açıklama yok'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Get.to(() => AddEditTodoView(todo: todo));
                    },
                  ),
                  Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      if (value != null) {
                        Get.find<HomeViewModel>().toggleTodoComplete(todo);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Silme Onayı'),
                            content: const Text(
                                'Bu todo\'yu silmek istediğinizden emin misiniz?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('İptal'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Sil'),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldDelete ?? false) {
                        Get.find<HomeViewModel>().deleteTodo(todo.id);
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                _showTodoDetails(context, todo);
              },
            ),
          );
        },
      );
    });
  }

  void _showTodoDetails(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(todo.title),
          content: Text(
              todo.description.isNotEmpty ? todo.description : 'Açıklama yok'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }
}
