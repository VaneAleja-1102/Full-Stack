import 'package:app/core/app/app_colors.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/widgets/common/app_drawer.dart';
import 'package:app/widgets/common/status_badge.dart';
import 'package:app/widgets/dashboard/dashboard_bottom_nav.dart';
import 'package:app/widgets/dashboard/dashboard_card.dart';
import 'package:app/widgets/dashboard/metric_box.dart';
import 'package:app/widgets/dashboard/outline_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardAdminPaisPage extends StatelessWidget {
  const DashboardAdminPaisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: _DashboardAppBar(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeHeader(),
            SizedBox(height: 20),
            _MetricsSection(),
            SizedBox(height: 16),
            _SolicitudesSection(),
            SizedBox(height: 16),
            _TestimoniosSection(),
            SizedBox(height: 16),
            _NoticiasSection(),
            SizedBox(height: 8),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: const DashboardBottomNav(currentIndex: 0),
    );
  }
}

class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: const Icon(Icons.menu_rounded, color: AppColors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Mi Panel',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _CountryChip(),
              const SizedBox(width: 10),
              const Icon(Icons.language_rounded, color: AppColors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        auth.country,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, ${auth.name}',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${auth.role} · ${auth.country}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return DashboardCard(
      title: 'Métricas del día',
      subtitle: '${auth.country} Comparte',
      badge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.metricDraftBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          auth.country.isNotEmpty ? auth.country.substring(0, 2).toUpperCase() : 'XX',
          style: const TextStyle(
            color: AppColors.metricDraftText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: const Row(
        children: [
          MetricBox(
            value: '5',
            label: 'PENDIENTES',
            valueColor: AppColors.metricPendingText,
            backgroundColor: AppColors.metricPendingBg,
          ),
          SizedBox(width: 8),
          MetricBox(
            value: '3',
            label: 'BORRADORES',
            valueColor: AppColors.metricDraftText,
            backgroundColor: AppColors.metricDraftBg,
          ),
          SizedBox(width: 8),
          MetricBox(
            value: '2',
            label: 'INACTIVOS',
            valueColor: AppColors.metricInactiveText,
            backgroundColor: AppColors.metricInactiveBg,
          ),
        ],
      ),
    );
  }
}

class _SolicitudesSection extends StatelessWidget {
  const _SolicitudesSection();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Últimas solicitudes',
      actionLabel: 'Ver todas',
      onAction: () => Navigator.pushNamed(context, '/solicitudes'),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Ir a solicitudes para ver el listado',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}

class _TestimoniosSection extends StatelessWidget {
  const _TestimoniosSection();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return DashboardCard(
      title: 'Mis testimonios',
      child: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('Ir a testimonios para gestionar',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
          const SizedBox(height: 12),
          if (!auth.isEditor)
            OutlineActionButton(
              label: 'Nuevo testimonio +',
              icon: Icons.add_circle_outline_rounded,
              onPressed: () => Navigator.pushNamed(context, '/testimonios/nuevo'),
            ),
        ],
      ),
    );
  }
}

class _NoticiasSection extends StatelessWidget {
  const _NoticiasSection();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return DashboardCard(
      title: 'Mis noticias',
      child: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('Ir a noticias para gestionar',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
          const SizedBox(height: 12),
          if (!auth.isEditor)
            OutlineActionButton(
              label: 'Nueva noticia +',
              icon: Icons.add_circle_outline_rounded,
              onPressed: () => Navigator.pushNamed(context, '/noticias/nuevo'),
            ),
        ],
      ),
    );
  }
}