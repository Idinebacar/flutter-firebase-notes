import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'register_screen.dart';
import '../../providers/auth_provider.dart';

import '../../core/utils/snackbar_utils.dart';
import '../../core/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(AppAuthProvider authProvider) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);

    if (emailError != null || passwordError != null) {
      SnackbarUtils.showSnackBar(
        context,
        emailError ?? passwordError!,
        isError: true,
      );
      return;
    }

    final success = await authProvider.login(email, password);

    if (!success && mounted) {
      SnackbarUtils.showSnackBar(
        context,
        authProvider.errorMessage,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AppAuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_note_rounded,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Text(
                    "Welcome Back",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Login to access your notes",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 15),

                  CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: "Login",
                          onPressed: () => _login(authProvider),
                        ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
