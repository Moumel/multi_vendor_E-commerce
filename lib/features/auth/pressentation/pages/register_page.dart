import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();

  String _selectedRole = 'customer'; // default

  void register() {
    final String name = userNameController.text.trim();
    final String email = emailController.text.trim();
    final String pw = pwController.text.trim();
    final String confirmPw = confirmPwController.text.trim();

    final authCubit = context.read<AuthCubit>();

    if (name.isEmpty || email.isEmpty || pw.isEmpty || confirmPw.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please complete all fields!")));
      return;
    }

    if (pw != confirmPw) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords do not match!")));
      return;
    }

    authCubit.register(name, email, pw, _selectedRole); // pass role
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    pwController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_open, size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 25),
              Text("Let's create an account", style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary)),
              const SizedBox(height: 25),

              MyTextfield(controller: userNameController, hintText: "User name", obscureText: false),
              const SizedBox(height: 10),
              MyTextfield(controller: emailController, hintText: "Email", obscureText: false),
              const SizedBox(height: 10),
              MyTextfield(controller: pwController, hintText: "Password", obscureText: true),
              const SizedBox(height: 10),
              MyTextfield(controller: confirmPwController, hintText: "Confirm Password", obscureText: true),
              const SizedBox(height: 20),

              // Role selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Register as: "),
                  DropdownButton<String>(
                    value: _selectedRole,
                    items: const [
                      DropdownMenuItem(value: 'customer', child: Text('Customer')),
                      DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),
              MyButton(onTap: register, text: "SIGN UP"),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(" Login now", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}