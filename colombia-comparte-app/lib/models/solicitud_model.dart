import 'package:flutter/material.dart';

enum SolicitudStatus { pendiente, gestionada, respondida }

class SolicitudModel {
  final String name;
  final String initials;
  final Color avatarStart;
  final Color avatarEnd;
  final String flag;
  final String country;
  final String city;
  final String countryCode;
  final Color codeTextColor;
  final Color codeBgColor;
  final String receivedTime;
  final String receivedDate;
  final SolicitudStatus status;
  final String email;
  final String phone;
  final String message;
  final String finalidad;

  const SolicitudModel({
    required this.name,
    required this.initials,
    required this.avatarStart,
    required this.avatarEnd,
    required this.flag,
    required this.country,
    required this.city,
    required this.countryCode,
    required this.codeTextColor,
    required this.codeBgColor,
    required this.receivedTime,
    required this.receivedDate,
    required this.status,
    required this.email,
    required this.phone,
    required this.message,
    required this.finalidad,
  });
}

const List<SolicitudModel> solicitudesMock = [
  SolicitudModel(
    name: 'Juan Pérez',
    initials: 'JP',
    avatarStart: Color(0xFF60A5FA),
    avatarEnd: Color(0xFF4F46E5),
    flag: '🇨🇴',
    country: 'Colombia',
    city: 'Bogotá, CO',
    countryCode: 'CO',
    codeTextColor: Color(0xFF1D4ED8),
    codeBgColor: Color(0xFFEFF6FF),
    receivedTime: 'Recibido hace 2h',
    receivedDate: 'Recibido el 14 Oct, 2023 • 10:45 AM',
    status: SolicitudStatus.pendiente,
    email: 'juan.perez@empresa.co',
    phone: '+57 310 456 7890',
    message:
        'Me gustaría obtener más información sobre los programas de '
        'voluntariado en la región de Antioquia para el próximo trimestre. '
        'Tengo experiencia previa en educación comunitaria y me gustaría '
        'saber cuáles son los requisitos para participar.',
    finalidad: 'Alianza',
  ),
  SolicitudModel(
    name: 'María González',
    initials: 'MG',
    avatarStart: Color(0xFF34D399),
    avatarEnd: Color(0xFF0D9488),
    flag: '🇨🇱',
    country: 'Chile',
    city: 'Santiago, CL',
    countryCode: 'CL',
    codeTextColor: Color(0xFFB91C1C),
    codeBgColor: Color(0xFFFEF2F2),
    receivedTime: 'Recibido hace 5h',
    receivedDate: 'Recibido el 14 Oct, 2023 • 07:30 AM',
    status: SolicitudStatus.gestionada,
    email: 'm.gonzalez@fundacion.cl',
    phone: '+56 9 8765 4321',
    message:
        'Consulta sobre la donación corporativa realizada el mes pasado '
        'y el certificado tributario correspondiente para la auditoría '
        'anual de nuestra fundación. Necesitamos el documento antes del '
        'cierre contable del trimestre.',
    finalidad: 'Donación',
  ),
  SolicitudModel(
    name: 'Ricardo Castillo',
    initials: 'RC',
    avatarStart: Color(0xFFFBBF24),
    avatarEnd: Color(0xFFEA580C),
    flag: '🇪🇨',
    country: 'Ecuador',
    city: 'Quito, EC',
    countryCode: 'EC',
    codeTextColor: Color(0xFFA16207),
    codeBgColor: Color(0xFFFEFCE8),
    receivedTime: 'Ayer',
    receivedDate: 'Recibido el 13 Oct, 2023 • 03:15 PM',
    status: SolicitudStatus.pendiente,
    email: 'rcastillo@correo.com',
    phone: '+593 2 123 4567',
    message:
        'Solicitud de apoyo para el comedor comunitario en Quito. '
        'Adjuntamos fotos de la situación actual y necesidades urgentes. '
        'Estamos atendiendo a más de 200 familias semanalmente y '
        'requerimos apoyo logístico y de voluntarios.',
    finalidad: 'Ayuda Social',
  ),
];
