import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.light(
          primary: AppColors.primaryPurple,
          secondary: AppColors.primaryPurpleLight,
          background: AppColors.formBackground,
          surface: AppColors.white,
          error: AppColors.errorColor,
        ),

        scaffoldBackgroundColor: AppColors.formBackground,

        // 🧠 TEXTO GLOBAL EN NEGRO (IMPORTANTE)
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          labelSmall: TextStyle(
            color: Colors.black,
            fontSize: 11,
          ),
        ),

        // 🔘 BOTONES
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),

        // 🧾 INPUTS GLOBAL (ESTO TE ARREGLA LOS FORMULARIOS)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black),
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryPurple),
          ),
        ),
      );
}