import 'package:app/core/app/app_theme.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/providers/country_provider.dart';
import 'package:app/providers/noticia_provider.dart';
import 'package:app/providers/solicitud_provider.dart';
import 'package:app/providers/testimonio_provider.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => SolicitudProvider()),
        ChangeNotifierProvider(create: (_) => TestimonioProvider()),
        ChangeNotifierProvider(create: (_) => NoticiaProvider()),
      ],
      child: MaterialApp(
        title: 'Latinoamérica Comparte',
        debugShowCheckedModeBanner: false,
        routes: routes,
        initialRoute: '/',
        theme: AppTheme.theme,
      ),
    );
  }
}