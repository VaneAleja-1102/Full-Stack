import 'package:app/widgets/common/status_badge.dart';
import 'package:flutter/material.dart';

class TestimonioModel {
  final String name;
  final String initials;
  final Color avatarColor;
  final String role;
  final String city;
  final String quote;
  final String date;
  final bool isVisible;
  final BadgeStatus status;

  const TestimonioModel({
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.role,
    required this.city,
    required this.quote,
    required this.date,
    required this.isVisible,
    required this.status,
  });
}

const List<TestimonioModel> testimoniosMock = [
  TestimonioModel(
    name: 'Mariana Restrepo',
    initials: 'MR',
    avatarColor: Color(0xFF7C3AC7),
    role: 'Líder Comunitaria',
    city: 'Medellín',
    quote:
        '"El apoyo recibido ha transformado la manera en que gestionamos los recursos en nuestra zona. Realmente se siente el cambio..."',
    date: '15 Oct, 2023',
    isVisible: true,
    status: BadgeStatus.published,
  ),
  TestimonioModel(
    name: 'Juan Pablo Duarte',
    initials: 'JP',
    avatarColor: Color(0xFF9B5FD4),
    role: 'Beneficiario',
    city: 'Cali',
    quote:
        '"Agradezco enormemente la oportunidad brindada. Los procesos son ahora mucho más claros y transparentes para todos."',
    date: 'Hoy, 09:42 AM',
    isVisible: false,
    status: BadgeStatus.draft,
  ),
  TestimonioModel(
    name: 'Carlos Vives G.',
    initials: 'CV',
    avatarColor: Color(0xFF4A1A7A),
    role: 'Donante',
    city: 'Bogotá',
    quote:
        '"La transparencia en el manejo de cada aporte es lo que me motiva a seguir colaborando con esta gran iniciativa regional."',
    date: '12 Oct, 2023',
    isVisible: false,
    status: BadgeStatus.unpublished,
  ),
  TestimonioModel(
    name: 'Andrea Sánchez',
    initials: 'AS',
    avatarColor: Color(0xFF7B3BC3),
    role: 'Voluntaria',
    city: 'Cartagena',
    quote:
        '"Ser parte de Latinoamérica Comparte me ha permitido conocer realidades que ahora podemos impactar positivamente."',
    date: '10 Oct, 2023',
    isVisible: true,
    status: BadgeStatus.published,
  ),
];
