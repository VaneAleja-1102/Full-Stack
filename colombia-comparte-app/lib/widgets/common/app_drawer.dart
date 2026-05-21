import 'package:app/core/app/app_colors.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
            decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
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
                Text(auth.name,
                    style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(auth.role,
                    style: const TextStyle(color: AppColors.whiteTransparent, fontSize: 13)),
                if (auth.country.isNotEmpty)
                  Text(auth.country,
                      style: const TextStyle(color: AppColors.whiteTransparent, fontSize: 12)),
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
                    if (auth.isSuperAdmin) {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    } else {
                      Navigator.pushReplacementNamed(context, '/dashboard/pais');
                    }
                  },
                ),
                if (auth.isSuperAdmin)
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
            onTap: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
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
      title: Text(label,
          style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}