import 'package:app/core/app/app_colors.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/widgets/auth/auth_header.dart';
import 'package:app/widgets/buttons/app_primary_button.dart';
import 'package:app/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    final role = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (!mounted) return;
    if (role != null) {
      if (role == 'superadmin') {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/dashboard/pais');
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(
              title: 'Bienvenido',
              subtitle: 'Inicia sesión para continuar',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: 'Correo electrónico',
                    hint: 'admin@latamcomparte.org',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Contraseña',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 16),
                  if (auth.error.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.errorColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.errorColor, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(auth.error,
                                style: const TextStyle(color: AppColors.errorColor, fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  AppPrimaryButton(
                    label: auth.isLoading ? 'Iniciando sesión...' : 'Iniciar sesión →',
                    onPressed: auth.isLoading ? null : _login,
                  ),
                  const SizedBox(height: 32),
                  const _SecurityDisclaimer(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityDisclaimer extends StatelessWidget {
  const _SecurityDisclaimer();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Acceso restringido únicamente a personal autorizado de\nLatinoamérica Comparte.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textHint, fontSize: 11, height: 1.6),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, color: AppColors.textHint, size: 14),
            SizedBox(width: 4),
            Text('SECURE CONNECT',
                style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8)),
          ],
        ),
      ],
    );
  }
}