# Latinoamérica Comparte — Panel administrativo

Aplicación **Flutter** que reproduce el panel administrativo y formularios públicos del proyecto **Latinoamérica Comparte**. Es un front-end orientado a mockups: datos en listas mock dentro de `lib/models/`, navegación con **rutas nombradas** y **sin gestores de estado externos** (solo `StatelessWidget` / `StatefulWidget` y estado local).

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) compatible con el `environment.sdk` definido en `pubspec.yaml` (actualmente **Dart ^3.10**).
- Editor recomendado: VS Code o Android Studio con extensiones Dart/Flutter.

## Ejecutar el proyecto

```bash
flutter pub get
flutter run
```

Para web (si está habilitado en el entorno):

```bash
flutter run -d chrome
```

## Estructura del código (`lib/`)

| Ruta | Propósito |
|------|-----------|
| `main.dart` | `MaterialApp`, tema global y mapa `routes`. |
| `core/app/` | Paleta (`AppColors`) y `ThemeData` (`AppTheme`). |
| `routes/routes.dart` | Definición de rutas nombradas. |
| `screens/` | Pantallas por dominio (auth, dashboard, portales, solicitudes, testimonios, noticias, contacto). |
| `models/` | Modelos de datos y listas mock para desarrollo. |
| `widgets/` | Componentes reutilizables (auth, botones, dashboard, portales, comunes, formularios). |

### Barrel de pantallas

`lib/screens/screens.dart` exporta todas las pantallas para que `routes.dart` mantenga imports simples.

## Rutas nombradas

| Ruta | Pantalla |
|------|----------|
| `/` | Carga inicial (`LoadingPage`) |
| `/login` | Inicio de sesión (`LoginPage`) |
| `/dashboard` | Dashboard super administrador (`DashboardSuperAdminPage`) |
| `/dashboard/pais` | Dashboard administrador por país (`DashboardAdminPaisPage`) |
| `/portales` | Lista de portales activos (`AllPortalsPage`) |
| `/solicitudes` | Lista de solicitudes de contacto (`RequestPage`) |
| `/solicitudes/detalle` | Detalle de una solicitud (`RequestDetailsPage`) |
| `/contenido` | Lista de testimonios (`TestimoniosPage`) |
| `/testimonios/nuevo` | Formulario de testimonio (`FormularioTestimoniosPage`) |
| `/noticias` | Lista de noticias (`NoticiasPage`) |
| `/noticias/nuevo` | Formulario de noticia (`FormularioNoticiasPage`) |
| `/contacto` | Formulario público de contacto (`ContactPage`) |

**Argumentos de ruta:** al abrir `/solicitudes/detalle` se espera un objeto `SolicitudModel` en `ModalRoute.settings.arguments` (la lista de solicitudes lo envía al navegar).

**Cierre de sesión:** desde el drawer, la acción de salida usa `Navigator.pushNamedAndRemoveUntil` hacia `/login` para limpiar la pila.

## Pantallas (resumen funcional)

- **Loading / Login:** entrada visual y formulario de acceso; enlaces de navegación hacia el flujo principal.
- **Dashboards:** métricas, tarjetas y listas resumidas (solicitudes, testimonios, noticias o países/actividad según rol).
- **Portales:** grid/listado de países con portal registrado (`PortalCard`).
- **Solicitudes:** filtros por chip, búsqueda en tiempo real con **resaltado** de coincidencias en varios campos.
- **Detalle solicitud:** información completa, cambio de estado con controles animados, zona de eliminación (mock).
- **Testimonios / Noticias:** filtros, tarjetas de lista, FAB con gradiente hacia formularios de alta.
- **Formularios (testimonios / noticias):** secciones en cards, campos reutilizables, selector de país, segmentos de estado.
- **Contacto público:** layout con header en gradiente, validación de correo y vista de éxito.

## Modelos (`lib/models/`)

Cada archivo define el tipo y, cuando aplica, una lista mock usada por las pantallas:

- `pais_model.dart` — `PaisModel`, `paisesMock`, `portalesActivosMock` (portales = países con datos de portal).
- `solicitud_model.dart` — `SolicitudModel`, estados y `solicitudesMock` (modelo único para lista y detalle).
- `testimonio_model.dart` — `TestimonioModel`, `testimoniosMock`.
- `noticia_model.dart` — `NoticiaModel`, `noticiasMock`.
- `actividad_model.dart` — actividad reciente del dashboard global.
- `resumen_contenido_model.dart` — resumen de contenidos para el dashboard global.

Se prioriza **un solo modelo por entidad** para evitar duplicar campos entre “lista” y “detalle”.

## Widgets reutilizables

### Autenticación y entradas base

- `widgets/auth/auth_header.dart` — cabecera del login.
- `widgets/inputs/app_text_field.dart` — campos de texto del flujo auth.
- `widgets/buttons/app_primary_button.dart` — botón primario.

### Dashboard

- `dashboard_card.dart`, `metric_box.dart`, `list_item_row.dart`, `outline_action_button.dart`, `status_badge.dart`, `dashboard_bottom_nav.dart` — tarjetas, métricas, filas de lista, botones secundarios, badges de estado y barra inferior.

### Portales

- `widgets/portales/portal_card.dart` — tarjeta de portal/país.

### Comunes

- `app_drawer.dart` — menú lateral global y secciones “próximamente”.
- `app_filter_bar.dart` — barra horizontal de chips con animación.
- `app_gradient_fab.dart` — FAB con gradiente.

### Formularios (extracción DRY)

- `widgets/forms/app_form_card.dart` — contenedor de sección para formularios.
- `widgets/forms/app_form_field.dart` — campo con etiqueta, prefijos, error y sufijos (p. ej. contador).
- `widgets/forms/app_country_dropdown.dart` — dropdown de país basado en `paisesMock`.
- `widgets/forms/app_segmented_selector.dart` — selector segmentado animado.

## Tema y colores

- `AppColors` concentra colores (primarios, fondos, bordes, badges, gradientes, errores).
- `AppTheme` construye `ThemeData` (modo oscuro, `ColorScheme` desde semilla, tipografía y `ElevatedButtonTheme`).
- `main.dart` asigna `theme: AppTheme.theme` al `MaterialApp`.

## Convenciones para quien colabora

1. **Nuevas pantallas:** widget en `lib/screens/<dominio>/`, export en `screens.dart`, entrada en `routes/routes.dart`.
2. **Nuevos datos:** preferir `lib/models/` + mock; evitar duplicar modelos para la misma entidad.
3. **UI repetida:** extraer a `lib/widgets/` antes de copiar secciones grandes entre pantallas.
4. **Estado:** usar `StatefulWidget` solo donde haya formularios, filtros o animación local; no se usa Provider/Riverpod/Bloc en esta etapa.
5. **Navegación:** `Navigator.pushNamed` / `pushNamedAndRemoveUntil`; mantener nombres de ruta en un solo mapa.

## Próximos pasos típicos

- Conectar API REST o GraphQL en lugar de mocks.
- Autenticación real y guardado de sesión.
- Pruebas widget/integration y CI.

## Recursos Flutter

- [Documentación Flutter](https://docs.flutter.dev/)
- [Dart language tour](https://dart.dev/guides/language/language-tour)
