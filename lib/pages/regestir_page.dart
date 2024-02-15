import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords dont match"),
        ),
      );
      return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(emailController.text,
          passwordController.text, usernameController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 110,
                  ),
                  const Icon(
                    Icons.message,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "ay aaml account",
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //emailtextfield
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Reenter Your Password",
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: usernameController,
                    hintText: "Username",
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyButton(onTap: signUp, text: 'Regestir'),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Text("3andk acc deja ?"),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
