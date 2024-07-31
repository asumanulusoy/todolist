import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/viewmodels/login_viewmodel.dart';
import 'package:todolist/components/atoms/custom_input_field.dart';
import 'package:todolist/components/atoms/custom_button.dart';
import 'package:todolist/views/register_view.dart';
import 'package:todolist/views/home_view.dart';

class LoginView extends StatelessWidget {
  final LoginViewModel loginViewModel = Get.put(LoginViewModel());

  @override
  Widget build(BuildContext context) {
    // Kullanıcı giriş yapmışsa, yönlendirme yapıyoruz
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print(
            'Giriş yapan kullanıcı: ${FirebaseAuth.instance.currentUser!.email}');
        Get.offAll(() => HomeView());
      });
      return const SizedBox.shrink(); // Boş bir widget döndür
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giriş Yap',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/login_icon.png',
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: loginViewModel.emailController,
                labelText: 'E-posta',
                icon: Icons.email,
              ),
              const SizedBox(height: 10),
              CustomInputField(
                controller: loginViewModel.passwordController,
                labelText: 'Şifre',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Giriş Yap',
                onPressed: loginViewModel.login,
                color: Colors.blue[700]!,
                icon: Icons.login,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.to(() => RegisterView());
                },
                child: Text(
                  'Hesabınız yok mu? Kayıt Olun',
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
