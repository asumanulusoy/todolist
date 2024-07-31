import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:todolist/models/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Asenkron olarak mevcut kullanıcıyı alır
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        // Firestore'dan kullanıcı bilgilerini al
        final userDoc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null) {
            return User.fromMap(userData);
          } else {
            print('User data is null');
          }
        }
      }
      return null;
    } catch (e) {
      print('Error fetching current user: $e');
      return null;
    }
  }

  // Kullanıcıyı çıkış yapar
  Future<void> logout() async {
    try {
      await _auth.signOut();
      if (Get.currentRoute != '/login') {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print('Error signing out: $e');
      Get.snackbar('Çıkış Hatası', 'Çıkış yapılamadı: $e');
    }
  }
}
