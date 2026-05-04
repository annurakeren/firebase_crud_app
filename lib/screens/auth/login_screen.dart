import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const LoginScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginWithFirebase() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password wajib diisi.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login gagal. Silakan coba lagi.';

      if (e.code == 'user-not-found') {
        message = 'User tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      } else if (e.code == 'user-disabled') {
        message = 'Akun ini telah dinonaktifkan.';
      } else if (e.code == 'invalid-credential') {
        message = 'Email atau password salah.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan. Silakan coba lagi.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> showForgotPasswordDialog() async {
    final forgotEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Lupa Password'),
        content: CustomTextField(
          controller: forgotEmailController,
          label: 'Masukkan Email',
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () {
              forgotEmailController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = forgotEmailController.text.trim();

              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email wajib diisi.'),
                  ),
                );
                return;
              }

              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: email,
                );

                forgotEmailController.dispose();

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Link reset password sudah dikirim ke email.'),
                  ),
                );
              } on FirebaseAuthException catch (e) {
                String message = 'Gagal mengirim link reset password.';

                if (e.code == 'invalid-email') {
                  message = 'Format email tidak valid.';
                } else if (e.code == 'user-not-found') {
                  message = 'User tidak ditemukan.';
                }

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 36),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.amberwood,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Masuk untuk mengelola data mahasiswa.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      controller: passwordController,
                      label: 'Password',
                      icon: Icons.lock_rounded,
                      obscureText: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed:
                        isLoading ? null : showForgotPasswordDialog,
                        child: const Text('Lupa Password?'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomButton(
                      text: isLoading ? 'Loading...' : 'Login',
                      icon: Icons.login_rounded,
                      onPressed: isLoading ? null : loginWithFirebase,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Gunakan akun yang sudah dibuat di Firebase Authentication.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}