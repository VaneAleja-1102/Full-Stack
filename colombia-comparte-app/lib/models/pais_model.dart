import 'package:app/widgets/common/status_badge.dart';
import 'package:flutter/material.dart';

class PaisModel {
  final String flag;
  final String name;
  final String code;
  final String? domain;
  final Color accentColor;
  final int solicitudes;
  final int noticias;
  final int testimonios;
  final BadgeStatus status;

  const PaisModel({
    required this.flag,
    required this.name,
    required this.code,
    this.domain,
    required this.accentColor,
    required this.solicitudes,
    this.noticias = 0,
    this.testimonios = 0,
    required this.status,
  });

  bool get tienePortal => domain != null;
}

const List<PaisModel> paisesMock = [
  PaisModel(
    flag: '🇨🇴',
    name: 'Colombia',
    code: 'COL',
    domain: 'latamcomparte.co',
    accentColor: Color(0xFFF59E0B),
    solicitudes: 87,
    noticias: 124,
    testimonios: 45,
    status: BadgeStatus.published,
  ),
  PaisModel(
    flag: '🇻🇪',
    name: 'Venezuela',
    code: 'VEN',
    accentColor: Color(0xFF7C3AC7),
    solicitudes: 54,
    status: BadgeStatus.published,
  ),
  PaisModel(
    flag: '🇪🇨',
    name: 'Ecuador',
    code: 'ECU',
    domain: 'latamcomparte.ec',
    accentColor: Color(0xFF0891B2),
    solicitudes: 41,
    noticias: 56,
    testimonios: 19,
    status: BadgeStatus.published,
  ),
  PaisModel(
    flag: '🇵🇪',
    name: 'Perú',
    code: 'PER',
    accentColor: Color(0xFFEA580C),
    solicitudes: 38,
    status: BadgeStatus.pending,
  ),
  PaisModel(
    flag: '🇲🇽',
    name: 'México',
    code: 'MEX',
    accentColor: Color(0xFF16A34A),
    solicitudes: 27,
    status: BadgeStatus.draft,
  ),
  PaisModel(
    flag: '🇨🇱',
    name: 'Chile',
    code: 'CHL',
    domain: 'latamcomparte.cl',
    accentColor: Color(0xFFDC2626),
    solicitudes: 31,
    noticias: 89,
    testimonios: 31,
    status: BadgeStatus.published,
  ),
];

List<PaisModel> get portalesActivosMock => paisesMock.where((p) => p.tienePortal).toList();
