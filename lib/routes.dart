import 'package:get/get.dart';
import 'package:todolist/views/todo/add_edit_todo_view.dart';
import 'package:todolist/views/home_view.dart';
import 'package:todolist/views/login_view.dart';
import 'package:todolist/views/register_view.dart';
import 'package:todolist/views/todo/todo_search_view.dart';

final List<GetPage> routes = [
  GetPage(name: '/login', page: () => LoginView()),
  GetPage(name: '/register', page: () => RegisterView()),
  GetPage(name: '/home', page: () => HomeView()),
  GetPage(name: '/add-todo', page: () => AddEditTodoView()),
  GetPage(name: '/todo-details', page: () => AddEditTodoView()),
  GetPage(name: '/todo-search', page: () => TodoSearchView()),
];
