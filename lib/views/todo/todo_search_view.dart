import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/viewmodels/home_viewmodel.dart';

class TodoSearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeViewModel _viewModel = Get.find<HomeViewModel>();
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Ara'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                _viewModel.searchTodos(query);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Ara',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.trim().isNotEmpty) {
                  _viewModel.searchTodos(value);
                } else {
                  _viewModel.searchResults.clear();
                }
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              final todos = _viewModel.searchResults;
              if (todos.isEmpty) {
                return const Center(child: Text('Sonuç bulunamadı.'));
              }
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700] ?? Colors.blue,
                        ),
                      ),
                      subtitle: Text(
                        todo.description.isNotEmpty
                            ? todo.description
                            : 'Açıklama yok',
                      ),
                      trailing: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          if (value != null) {
                            _viewModel.toggleTodoComplete(todo);
                          }
                        },
                      ),
                      onTap: () {
                        Get.toNamed('/todo-details', arguments: todo);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
