import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist/models/todo.dart';

class TodoService {
  final CollectionReference _firebaseTodos =
      FirebaseFirestore.instance.collection('todos');
  final GetStorage _storage = GetStorage();

  // Todo ekleme işlemi
  Future<void> addTodo(Todo todo) async {
    try {
      DocumentReference docRef = await _firebaseTodos.add(todo.toMap());
      String newId = docRef.id;
      Todo newTodo = todo.copyWith(id: newId);
      await _firebaseTodos.doc(newId).set(newTodo.toMap());

      // Cache güncelleme
      await _updateCache();
    } catch (e) {
      throw Exception('Todo eklenirken bir hata oluştu: $e');
    }
  }

  // Todo güncelleme işlemi
  Future<void> updateTodo({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required DateTime createdAt,
    DateTime? completedAt,
  }) async {
    try {
      if (id.isEmpty) {
        throw Exception('Belge kimliği boş olamaz');
      }

      await _firebaseTodos.doc(id).update({
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'createdAt': Timestamp.fromDate(createdAt),
        'completedAt':
            completedAt != null ? Timestamp.fromDate(completedAt) : null,
      });

      // Cache güncelleme
      await _updateCache();
    } catch (e) {
      throw Exception('Todo güncellenirken bir hata oluştu: $e');
    }
  }

  // Todo silme işlemi
  Future<void> deleteTodo(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('Belge kimliği boş olamaz');
      }

      await _firebaseTodos.doc(id).delete();

      // Cache güncelleme
      await _updateCache();
    } catch (e) {
      throw Exception('Todo silinirken bir hata oluştu: $e');
    }
  }

  // Todos listesini alma işlemi
  Future<List<Todo>> getTodos() async {
    try {
      // Cache'den verileri al
      final cachedTodos = _storage.read<List<dynamic>>('todos');
      if (cachedTodos != null) {
        return cachedTodos
            .map((map) =>
                Todo.fromMap(Map<String, dynamic>.from(map), map['id'] ?? ''))
            .toList();
      }

      // Cache'de veri yoksa Firestore'dan al
      final snapshot =
          await _firebaseTodos.orderBy('createdAt', descending: true).get();

      // Firestore'dan alınan veriyi Todo modeline dönüştür
      final todos = snapshot.docs.map((doc) => Todo.fromDocument(doc)).toList();

      // Cache'e yaz
      await _storage.write('todos', todos.map((todo) => todo.toMap()).toList());

      return todos;
    } catch (e) {
      throw Exception('Todos alınırken bir hata oluştu: $e');
    }
  }

  // Cache'i güncelleme işlemi
  Future<void> _updateCache() async {
    try {
      final snapshot =
          await _firebaseTodos.orderBy('createdAt', descending: true).get();
      final todos = snapshot.docs.map((doc) => Todo.fromDocument(doc)).toList();
      await _storage.write('todos', todos.map((todo) => todo.toMap()).toList());
    } catch (e) {
      throw Exception('Cache güncellenirken bir hata oluştu: $e');
    }
  }
}
