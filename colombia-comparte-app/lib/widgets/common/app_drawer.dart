import 'package:app/core/app/app_colors.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _authService = AuthService();
  String _name = '';
  String _role = '';
  String _country = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _role = prefs.getString('role') ?? '';
      _country = prefs.getString('country') ?? '';
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: AppColors.white, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  _name,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _role,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 13,
                  ),
                ),
                if (_country.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _country,
                    style: const TextStyle(
                      color: AppColors.whiteTransparent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    if (_role == 'superadmin') {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    } else {
                      Navigator.pushReplacementNamed(context, '/dashboard/pais');
                    }
                  },
                ),
                if (_role == 'superadmin')
                  _DrawerItem(
                    icon: Icons.public_outlined,
                    label: 'Portales',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/portales');
                    },
                  ),
                _DrawerItem(
                  icon: Icons.inbox_outlined,
                  label: 'Solicitudes',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/solicitudes');
                  },
                ),
                _DrawerItem(
                  icon: Icons.format_quote_outlined,
                  label: 'Testimonios',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/contenido');
                  },
                ),
                _DrawerItem(
                  icon: Icons.newspaper_outlined,
                  label: 'Noticias',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/noticias');
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.logout_rounded,
            label: 'Cerrar sesión',
            color: AppColors.errorColor,
            onTap: _logout,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primaryPurple, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}