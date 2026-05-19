import 'package:app/core/app/app_theme.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latinoamérica Comparte',
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: '/',
      theme: AppTheme.theme,
    );
  }
}

//TODO: CREAR EL MODELO DEL USUARIO, PORQUE A PARTIR DE EL DEBERIAMOS DEFINIR LOS PERMISOS DE CADA USUARIO, Y QUE PANTALLAS SE PUEDEN VER Y QUE ACCIONES SE PUEDEN REALIZAR.

//TODO: DEBERIA MOSTRAR LOS 3 DASHBOARD, 
//USUARIO NORMAL -> ¿DEBERIA TENER UN DASHBOARD? (REVISAR LA PAGINA PARA VER ESO Y ASI DEFINIR SI SU ALCANCE ES SOLO DE LECTURA)
//USUARIO ADMIN POR PAIS,
//USUARIO SUPER -> ADMINISTRADOR -> DEBE VER LA LISTA DE PORTALES, ACTIVAR PORTALES, VER VISTA SUPER ADMINISTRADOR, QUE TIENE METRICAS GLOBALES, PAISES ACTIVOS, ACTIVIDAD RECENTE, RESUMEN DE CONTENIDO (HAY QUE TERMINAR DE DISEÑAR ESTO)


//PODRIAMOS NODIFICAR EL CONTENIDO DE LAS PAGINAS POR MEDIO DEL BAG DEL APPBAR (COLOMBIA), Y QUE LAS OPERACIONES SE HAGAN DE ACUERDO A ELLO

//TODO: EN LA PANTALLA DE TESTIMONIOS, EL BAG DE VISIBILIDAD DEBEIRA APARECER SOLO SI SOY SUPER ADMINISTRADOR, y solo se deben mostrar todos los testimonios al super administrador, si el usuario es admin por pais, solo se deben mostrar los testimonios de su pais, si el usuario es normal, solo se deben mostrar los testimonios publicados.
//TODO: DESHABILITAR EL BOTON DE AGREGAR TESTIMONIO PARA USUARIOS NORMALES, Y DECIDIR SI SE DEBE MOSTRAR EL BOTON DE AGREGAR TESTIMONIO PARA USUARIOS ADMIN POR PAIS Y SUPER ADMINISTRADOR.
//TODO: HACER QUE LOS LABELS DE LAS PANTALLAS SEAN ACRODES A LOS MODELOS, Y QUE SEAN MAS GENERICOS.


//TODO: EN LA PANTALLA DE NOTICIAS, EL BAG DE VISIBILIDAD DEBEIRA APARECER SOLO SI SOY SUPER ADMINISTRADOR, y solo se deben mostrar todos los testimonios al super administrador, si el usuario es admin por pais, solo se deben mostrar los testimonios de su pais, si el usuario es normal, solo se deben mostrar los testimonios publicados.
//TODO: DESHABILITAR EL BOTON DE AGREGAR NOTICIA PARA USUARIOS NORMALES, Y DECIDIR SI SE DEBE MOSTRAR EL BOTON DE AGREGAR NOTICIA PARA USUARIOS ADMIN POR PAIS Y SUPER ADMINISTRADOR.

