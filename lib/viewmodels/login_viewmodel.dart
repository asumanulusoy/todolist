import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/views/home_view.dart';

class LoginViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Hata', 'Geçersiz e-posta formatı');
      return;
    }
    if (password.length < 8) {
      Get.snackbar('Hata', 'Şifre en az 8 karakter uzunluğunda olmalıdır');
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Oturum açma başarılıysa yönlendir
      if (userCredential.user != null) {
        Get.offAll(() => HomeView());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Hata', e.message ?? 'Bilinmeyen bir hata oluştu');
    } catch (e) {
      Get.snackbar('Hata', 'Beklenmeyen bir hata oluştu');
    }
  }
}
