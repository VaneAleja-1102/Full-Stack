import 'package:app/widgets/common/status_badge.dart';
import 'package:flutter/material.dart';

class NoticiaModel {
  final String title;
  final String category;
  final Color categoryColor;
  final String author;
  final String authorInitials;
  final Color authorColor;
  final String date;
  final String excerpt;
  final Color thumbnailColor;
  final IconData thumbnailIcon;
  final bool hasImage;
  final Color borderColor;
  final bool isVisible;
  final BadgeStatus status;

  const NoticiaModel({
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.author,
    required this.authorInitials,
    required this.authorColor,
    required this.date,
    required this.excerpt,
    required this.thumbnailColor,
    required this.thumbnailIcon,
    this.hasImage = true,
    this.borderColor = const Color(0xFFFACC15),
    required this.isVisible,
    required this.status,
  });
}

const List<NoticiaModel> noticiasMock = [
  NoticiaModel(
    title: 'Transformando comunidades a través del reciclaje creativo en Antioquia',
    category: 'INSPIRACIÓN',
    categoryColor: Color(0xFF7B2D8B),
    author: 'María Castro',
    authorInitials: 'MC',
    authorColor: Color(0xFF9B5FD4),
    date: '12 Oct 2023',
    excerpt:
        'El proyecto "EcoArte" ha logrado integrar a más de 50 familias en una red de economía circular que genera ingresos dignos...',
    thumbnailColor: Color(0xFF4A7C59),
    thumbnailIcon: Icons.groups_outlined,
    hasImage: true,
    isVisible: true,
    status: BadgeStatus.published,
  ),
  NoticiaModel(
    title: 'Nuevas alianzas estratégicas para la expansión en 2024',
    category: 'CORPORATIVO',
    categoryColor: Color(0xFF6B6B8A),
    author: 'Juan Delgado',
    authorInitials: 'JD',
    authorColor: Color(0xFF4F72E3),
    date: 'Hace 2 horas',
    excerpt:
        'Estamos en conversaciones avanzadas con tres organizaciones internacionales para fortalecer el apoyo logístico en la región...',
    thumbnailColor: Color(0xFFD0D0E0),
    thumbnailIcon: Icons.handshake_outlined,
    hasImage: false,
    borderColor: Color(0xFFFACC15),
    isVisible: false,
    status: BadgeStatus.draft,
  ),
  NoticiaModel(
    title: 'Educación digital: Rompiendo brechas en el Pacífico Colombiano',
    category: 'INSPIRACIÓN',
    categoryColor: Color(0xFF7B2D8B),
    author: 'Ana Rojas',
    authorInitials: 'AR',
    authorColor: Color(0xFFD4548B),
    date: '05 Oct 2023',
    excerpt:
        'Un programa de alfabetización digital llega a zonas rurales del Pacífico colombiano beneficiando a más de 2.000 estudiantes.',
    thumbnailColor: Color(0xFF5B5EA6),
    thumbnailIcon: Icons.school_outlined,
    hasImage: true,
    isVisible: true,
    status: BadgeStatus.published,
  ),
];
