import 'package:app/core/app/app_colors.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final loggedIn = await _authService.isLoggedIn();
    if (!mounted) return;

    if (loggedIn) {
      final role = await _authService.getRole();
      if (role == 'superadmin') {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/dashboard/pais');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'v1.0',
                      style: TextStyle(
                        color: AppColors.whiteTransparent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.public,
                    size: 48,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Latinoamérica Comparte',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Panel Administrativo',
                  style: TextStyle(
                    color: AppColors.whiteTransparent,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                const CircularProgressIndicator(color: AppColors.white),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}