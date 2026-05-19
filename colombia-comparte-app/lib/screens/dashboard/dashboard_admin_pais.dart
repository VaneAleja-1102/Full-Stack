import 'package:app/core/app/app_colors.dart';
import 'package:app/models/noticia_model.dart';
import 'package:app/widgets/common/app_drawer.dart';
import 'package:app/models/solicitud_model.dart';
import 'package:app/models/testimonio_model.dart';
import 'package:app/widgets/common/status_badge.dart';
import 'package:app/widgets/dashboard/dashboard_bottom_nav.dart';
import 'package:app/widgets/dashboard/dashboard_card.dart';
import 'package:app/widgets/dashboard/list_item_row.dart';
import 'package:app/widgets/dashboard/metric_box.dart';
import 'package:app/widgets/dashboard/outline_action_button.dart';
import 'package:flutter/material.dart';

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

// ─── AppBar ───────────────────────────────────────────────────────────────────

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
              const Icon(Icons.language_rounded,
                  color: AppColors.white, size: 22),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🇨🇴', style: TextStyle(fontSize: 13)),
          SizedBox(width: 5),
          Text(
            'Colombia',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Welcome ──────────────────────────────────────────────────────────────────

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, Marcela',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Administradora · Colombia',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}

// ─── Metrics ──────────────────────────────────────────────────────────────────

class _MetricsSection extends StatelessWidget {
  const _MetricsSection();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Métricas del día',
      subtitle: 'Colombia Comparte',
      badge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.metricDraftBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'CO',
          style: TextStyle(
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

// ─── Solicitudes ──────────────────────────────────────────────────────────────

class _SolicitudesSection extends StatelessWidget {
  const _SolicitudesSection();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Últimas solicitudes',
      actionLabel: 'Ver todas',
      onAction: () {},
      child: Column(
        children: List.generate(solicitudesMock.length, (i) {
          final item = solicitudesMock[i];
          return ListItemRow(
            title: item.name,
            subtitle: item.city,
            leading: AvatarLeading(initials: item.initials),
            trailing: const StatusBadge(status: BadgeStatus.pending),
            showDivider: i < solicitudesMock.length - 1,
          );
        }),
      ),
    );
  }
}

// ─── Testimonios ──────────────────────────────────────────────────────────────

class _TestimoniosSection extends StatelessWidget {
  const _TestimoniosSection();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Mis testimonios',
      child: Column(
        children: [
          ...List.generate(testimoniosMock.length, (i) {
            final t = testimoniosMock[i];
            return ListItemRow(
              title: t.name,
              subtitle: '',
              leading: AvatarLeading(initials: t.initials, color: t.avatarColor),
              trailing: StatusBadge(status: t.status),
              showDivider: i < testimoniosMock.length - 1,
            );
          }),
          const SizedBox(height: 12),
          OutlineActionButton(
            label: 'Nuevo testimonio +',
            icon: Icons.add_circle_outline_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ─── Noticias ─────────────────────────────────────────────────────────────────

class _NoticiasSection extends StatelessWidget {
  const _NoticiasSection();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Mis noticias',
      child: Column(
        children: [
          ...List.generate(noticiasMock.length, (i) {
            final n = noticiasMock[i];
            return ListItemRow(
              title: n.title,
              subtitle: '',
              leading: ImageLeading(color: n.thumbnailColor, icon: n.thumbnailIcon),
              trailing: StatusBadge(status: n.status),
              showDivider: i < noticiasMock.length - 1,
            );
          }),
          const SizedBox(height: 12),
          OutlineActionButton(
            label: 'Nueva noticia +',
            icon: Icons.add_circle_outline_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
