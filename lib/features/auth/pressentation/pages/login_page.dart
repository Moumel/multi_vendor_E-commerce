
// login page UI

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text controller
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  late final authCubit = context.read<AuthCubit>();

  void login(){
    final String email = emailController.text;
    final String pw = pwController.text;


    if (email.isNotEmpty && pw.isNotEmpty) {
      authCubit.login(email, pw);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter both email and password!")));
    }
  }

  void openForgotPasswordBox(){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: const Text("Forgot Password?"),
      content: MyTextfield(
        controller: emailController,
        hintText: "Enter email",
        obscureText: false,
      ),
      actions: [
        TextButton(
          onPressed: ()=> Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            String message = await authCubit.forgotPassowrd(emailController.text);

            if(message == "Password reset email sent! Check your inbox"){
              Navigator.pop(context);
              emailController.clear();
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          },
          child: const Text("Reset"),
        ),
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_open, size: 80, color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 25),

              Text(
                "L U X U R Y", style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary),
              ),

              const SizedBox(height: 25),

              //email text field
              MyTextfield(controller: emailController, hintText: "Email", obscureText: false),

              const SizedBox(height: 10),

              //pw text field
              MyTextfield(controller: pwController, hintText: "Password", obscureText: true),

              const SizedBox(height: 10),

              //forgot pw
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: ()=> openForgotPasswordBox(),
                    child: Text("Forgot password?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              //login
              MyButton(
                onTap: login,
                text: "LOGIN",
              ),

              const SizedBox(height: 25),

              // register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary
                      ),),
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
