import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/viewmodels/register_viewmodel.dart';
import 'package:todolist/components/atoms/custom_input_field.dart';
import 'package:todolist/components/atoms/custom_button.dart';
import 'package:todolist/views/login_view.dart';

class RegisterView extends StatelessWidget {
  final RegisterViewModel _viewModel = Get.put(RegisterViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kayıt Ol',
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
                  'assets/images/register_icon.png',
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: _viewModel.emailController,
                labelText: 'E-posta',
                icon: Icons.email,
              ),
              const SizedBox(height: 10),
              CustomInputField(
                controller: _viewModel.passwordController,
                labelText: 'Şifre',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              CustomInputField(
                controller: _viewModel.nameController,
                labelText: 'Ad',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              Obx(() => _viewModel.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: 'Kayıt Ol',
                      onPressed: () => _viewModel.register(),
                      color: Colors.blue[700]!,
                      icon: Icons.person_add,
                    )),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.to(() => LoginView()),
                child: Text(
                  'Hesabınız var mı? Giriş Yapın',
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
