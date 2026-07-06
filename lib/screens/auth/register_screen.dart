import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../providers/auth_provider.dart';

import '../../core/utils/snackbar_utils.dart';
import '../../core/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register(AppAuthProvider authProvider) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final nameError = name.isEmpty ? "Name is required" : null;
    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);
    final confirmError = Validators.validateConfirmPassword(
      confirmPassword,
      password,
    );

    final firstError = nameError ?? emailError ?? passwordError ?? confirmError;

    if (firstError != null) {
      SnackbarUtils.showSnackBar(context, firstError, isError: true);
      return;
    }

    final success = await authProvider.register(email, password, name);

    if (success && mounted) {
      Navigator.pop(context);
    } else if (mounted) {
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
                  const SizedBox(height: 20),
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Start managing your notes today",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: nameController,
                    hintText: "Full Name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    icon: Icons.lock_clock_outlined,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: "Register",
                          onPressed: () => _register(authProvider),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
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
