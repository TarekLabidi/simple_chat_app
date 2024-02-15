import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                //icon
                const Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(
                  height: 30,
                ),
                //text
                const Text(
                  "Salamou 3alykom",
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
                  height: 50,
                ),
                MyButton(onTap: signIn, text: 'Sign In'),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Text("jdid lena ?"),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "A3mel Acc",
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
    );
  }
}
