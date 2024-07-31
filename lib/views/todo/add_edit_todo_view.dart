import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/services/todo_service.dart';
import 'package:todolist/viewmodels/home_viewmodel.dart';

class AddEditTodoView extends StatefulWidget {
  final Todo? todo;

  AddEditTodoView({this.todo});

  @override
  _AddEditTodoViewState createState() => _AddEditTodoViewState();
}

class _AddEditTodoViewState extends State<AddEditTodoView> {
  final TodoService _todoService = TodoService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      descriptionController.text = widget.todo!.description;
    }
  }

  void addTodo() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Hata', 'Başlık ve açıklama boş bırakılamaz.');
      return;
    }

    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: titleController.text,
      description: descriptionController.text,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    try {
      await _todoService.addTodo(newTodo);
      Get.find<HomeViewModel>().fetchTodos(); // Verileri güncelle
      Get.offAllNamed('/home'); // Anasayfaya geri dön
    } catch (e) {
      Get.snackbar('Hata', 'Todo eklenirken bir hata oluştu: $e');
    }
  }

  void updateTodo() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Hata', 'Başlık ve açıklama boş bırakılamaz.');
      return;
    }

    final updatedTodo = Todo(
      id: widget.todo!.id,
      title: titleController.text,
      description: descriptionController.text,
      isCompleted: widget.todo!.isCompleted,
      createdAt: widget.todo!.createdAt,
      completedAt: widget.todo!.completedAt,
    );

    try {
      await _todoService.updateTodo(
        id: updatedTodo.id,
        title: updatedTodo.title,
        description: updatedTodo.description,
        isCompleted: updatedTodo.isCompleted,
        createdAt: updatedTodo.createdAt,
        completedAt: updatedTodo.completedAt,
      );
      Get.find<HomeViewModel>().fetchTodos(); // Verileri güncelle
      Get.back(); // Önceki ekrana dön
    } catch (e) {
      Get.snackbar('Hata', 'Todo güncellenirken bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo != null ? 'Todo Düzenle' : 'Yeni Todo Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (widget.todo != null) {
                  updateTodo();
                } else {
                  addTodo();
                }
              },
              child: Text(widget.todo != null ? 'Güncelle' : 'Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
