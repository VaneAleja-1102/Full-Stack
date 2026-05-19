import 'package:app/core/app/app_colors.dart';
import 'package:app/models/actividad_model.dart';
import 'package:app/models/pais_model.dart';
import 'package:app/models/resumen_contenido_model.dart';
import 'package:app/widgets/common/app_drawer.dart';
import 'package:app/widgets/common/status_badge.dart';
import 'package:app/widgets/dashboard/dashboard_bottom_nav.dart';
import 'package:app/widgets/dashboard/dashboard_card.dart';
import 'package:app/widgets/dashboard/list_item_row.dart';
import 'package:app/widgets/dashboard/metric_box.dart';
import 'package:flutter/material.dart';

class DashboardSuperAdminPage extends StatelessWidget {
  const DashboardSuperAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: _SuperAdminAppBar(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeHeader(),
            SizedBox(height: 20),
            _GlobalMetricsSection(),
            SizedBox(height: 16),
            _PaisesActivosSection(),
            SizedBox(height: 16),
            _ActividadRecienteSection(),
            SizedBox(height: 16),
            _ResumenContenidoSection(),
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

class _SuperAdminAppBar extends StatelessWidget implements PreferredSizeWidget {
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
                  'Panel Global',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _GlobalBadge(),
              const SizedBox(width: 10),
              Stack(
                children: [
                  const Icon(Icons.notifications_outlined,
                      color: AppColors.white, size: 24),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.statusPendingText,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlobalBadge extends StatelessWidget {
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
          Icon(Icons.public_rounded, color: AppColors.white, size: 13),
          SizedBox(width: 5),
          Text(
            'Global',
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
          'Hola, Carlos',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Super Administrador · Latinoamérica Comparte',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

// ─── Global Metrics ───────────────────────────────────────────────────────────

class _GlobalMetricsSection extends StatelessWidget {
  const _GlobalMetricsSection();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Métricas globales',
      subtitle: 'Todos los países · Hoy',
      child: const Column(
        children: [
          Row(
            children: [
              MetricBox(
                value: '247',
                label: 'SOLICITUDES',
                valueColor: AppColors.metricPendingText,
                backgroundColor: AppColors.metricPendingBg,
              ),
              SizedBox(width: 8),
              MetricBox(
                value: '83',
                label: 'TESTIMONIOS',
                valueColor: AppColors.metricDraftText,
                backgroundColor: AppColors.metricDraftBg,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              MetricBox(
                value: '1.2k',
                label: 'USUARIOS',
                valueColor: AppColors.statusPublishedText,
                backgroundColor: AppColors.statusPublishedBg,
              ),
              SizedBox(width: 8),
              MetricBox(
                value: '6',
                label: 'PAÍSES',
                valueColor: AppColors.metricInactiveText,
                backgroundColor: AppColors.metricInactiveBg,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Países Activos ───────────────────────────────────────────────────────────

class _PaisesActivosSection extends StatelessWidget {
  const _PaisesActivosSection();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Países activos',
      actionLabel: 'Ver todos',
      onAction: () {},
      child: Column(
        children: List.generate(paisesMock.length, (i) {
          final p = paisesMock[i];
          return ListItemRow(
            title: p.name,
            subtitle: '${p.solicitudes} solicitudes',
            leading: _FlagAvatar(flag: p.flag),
            trailing: StatusBadge(status: p.status),
            showDivider: i < paisesMock.length - 1,
          );
        }),
      ),
    );
  }
}

class _FlagAvatar extends StatelessWidget {
  final String flag;
  const _FlagAvatar({required this.flag});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.metricDraftBg,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(flag, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}

// ─── Actividad Reciente ───────────────────────────────────────────────────────

class _ActividadRecienteSection extends StatelessWidget {
  const _ActividadRecienteSection();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Actividad reciente',
      actionLabel: 'Ver todo',
      onAction: () {},
      child: Column(
        children: List.generate(actividadRecienteMock.length, (i) {
          final item = actividadRecienteMock[i];
          return ListItemRow(
            title: item.title,
            subtitle: item.subtitle,
            leading: _ActivityIcon(
              icon: item.icon,
              color: item.color,
              bgColor: item.bgColor,
            ),
            showDivider: i < actividadRecienteMock.length - 1,
          );
        }),
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _ActivityIcon({
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

// ─── Resumen de Contenido ─────────────────────────────────────────────────────

class _ResumenContenidoSection extends StatelessWidget {
  const _ResumenContenidoSection();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Resumen de contenido',
      subtitle: 'Publicaciones totales',
      child: Column(
        children: List.generate(resumenContenidoMock.length, (i) {
          final item = resumenContenidoMock[i];
          return Column(
            children: [
              _ContentRow(
                icon: item.icon,
                color: item.color,
                label: item.label,
                published: item.published,
                draft: item.draft,
              ),
              if (i < resumenContenidoMock.length - 1) ...[
                const SizedBox(height: 4),
                const Divider(height: 1, color: AppColors.inputBorder),
                const SizedBox(height: 4),
              ],
            ],
          );
        }),
      ),
    );
  }
}

class _ContentRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int published;
  final int draft;

  const _ContentRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.published,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$published publicados',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$draft borradores',
                style: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
