import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist/models/user.dart';
import 'package:todolist/views/login_view.dart';

class RegisterViewModel extends GetxController {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  var isLoading = false.obs;

  void register() async {
    final email = emailController.text;
    final password = passwordController.text;
    final name = nameController.text;

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Hata', 'Geçersiz e-posta formatı');
      return;
    }
    if (password.length < 8) {
      Get.snackbar('Hata', 'Şifre en az 8 karakter uzunluğunda olmalıdır');
      return;
    }
    if (name.isEmpty) {
      Get.snackbar('Hata', 'İsim boş olamaz');
      return;
    }

    isLoading.value = true;

    try {
      final auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final auth.User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final user = User(
          uid: firebaseUser.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(user.toMap());
      }

      Get.offAll(() => LoginView());
    } on auth.FirebaseAuthException catch (e) {
      Get.snackbar('Hata', e.message ?? 'Bilinmeyen bir hata oluştu');
    } catch (e) {
      Get.snackbar('Hata', 'Beklenmeyen bir hata oluştu');
    } finally {
      isLoading.value = false;
    }
  }
}
