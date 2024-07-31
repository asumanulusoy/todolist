import 'package:get/get.dart';
import 'package:todolist/services/todo_service.dart';
import 'package:todolist/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class HomeViewModel extends GetxController with SingleGetTickerProviderMixin {
  final TodoService _todoService = TodoService();

  RxList<Todo> incompleteTodos = <Todo>[].obs;
  RxList<Todo> completeTodos = <Todo>[].obs;
  RxList<Todo> searchResults = <Todo>[].obs;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchTodos(); // Fetch todos on initialization
  }

  Future<void> fetchTodos() async {
    try {
      final todos = await _todoService.getTodos();
      incompleteTodos.value = todos.where((todo) => !todo.isCompleted).toList();
      completeTodos.value = todos.where((todo) => todo.isCompleted).toList();
    } catch (e) {
      print('Hata: $e');
      Get.snackbar('Veri Alma Hatası', 'Todos alınırken bir hata oluştu: $e');
    }
  }

  void addTodo(String title, String description) async {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    try {
      await _todoService.addTodo(todo);
      fetchTodos(); // Refresh todos list
      Get.back(); // Close the add/edit screen
    } catch (e) {
      Get.snackbar('Ekleme Hatası', 'Todo eklenirken bir hata oluştu: $e');
    }
  }

  void updateTodo(Todo updatedTodo) async {
    try {
      await _todoService.updateTodo(
        id: updatedTodo.id,
        title: updatedTodo.title,
        description: updatedTodo.description,
        isCompleted: updatedTodo.isCompleted,
        createdAt: updatedTodo.createdAt,
        completedAt: updatedTodo.completedAt,
      );
      fetchTodos(); // Refresh todos list
      Get.back(); // Close the add/edit screen
    } catch (e) {
      Get.snackbar(
          'Güncelleme Hatası', 'Todo güncellenirken bir hata oluştu: $e');
    }
  }

  void toggleTodoComplete(Todo todo) async {
    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      completedAt: !todo.isCompleted ? DateTime.now() : null,
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
      fetchTodos(); // Refresh todos list
    } catch (e) {
      Get.snackbar(
          'Tamamlama Hatası', 'Todo tamamlanırken bir hata oluştu: $e');
    }
  }

  void searchTodos(String query) async {
    try {
      final todos = await _todoService.getTodos();
      searchResults.value = todos
          .where((todo) =>
              todo.title.toLowerCase().contains(query.toLowerCase()) ||
              todo.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      Get.snackbar('Arama Hatası', 'Todo arama sırasında bir hata oluştu: $e');
    }
  }

  void deleteTodo(String id) async {
    try {
      await _todoService.deleteTodo(id);
      fetchTodos(); // Refresh todos list
    } catch (e) {
      Get.snackbar('Silme Hatası', 'Todo silinirken bir hata oluştu: $e');
    }
  }

  void logout() async {
    try {
      await firebase_auth.FirebaseAuth.instance.signOut();
      if (Get.currentRoute != '/login') {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar('Çıkış Hatası', 'Çıkış yapılamadı: $e');
    }
  }
}
