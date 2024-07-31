import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/viewmodels/home_viewmodel.dart';
import 'package:todolist/components/organisms/todo_list_view.dart';
import 'package:todolist/views/todo/todo_search_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeViewModel _viewModel = Get.put(HomeViewModel());
    final Color appBarColor = Colors.blue[700] ?? Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.to(() => TodoSearchView()),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _viewModel.logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Material(
            color: appBarColor,
            child: TabBar(
              controller: _viewModel.tabController,
              tabs: const [
                Tab(text: 'Tamamlanmamış'),
                Tab(text: 'Tamamlanmış'),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[300],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _viewModel.tabController,
              children: [
                TodoListView(todos: _viewModel.incompleteTodos),
                TodoListView(todos: _viewModel.completeTodos),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appBarColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Get.toNamed('/add-todo');
        },
      ),
    );
  }
}
