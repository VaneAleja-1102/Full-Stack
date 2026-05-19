import 'package:app/core/app/app_colors.dart';
import 'package:app/models/pais_model.dart';
import 'package:app/widgets/forms/app_country_dropdown.dart';
import 'package:app/widgets/forms/app_form_field.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _empresaController = TextEditingController();
  final _cargoController = TextEditingController();
  final _emailController = TextEditingController();
  final _mensajeController = TextEditingController();

  String _phoneCode = '+57';
  PaisModel? _selectedCountry;
  bool _emailError = false;
  bool _sent = false;

  static const _phoneCodes = [
    (code: '+57', flag: '🇨🇴'),
    (code: '+56', flag: '🇨🇱'),
    (code: '+593', flag: '🇪🇨'),
    (code: '+51', flag: '🇵🇪'),
    (code: '+52', flag: '🇲🇽'),
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _empresaController.dispose();
    _cargoController.dispose();
    _emailController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email);
  }

  void _onSubmit() {
    final email = _emailController.text;
    final hasError = email.isNotEmpty && !_isValidEmail(email);
    setState(() => _emailError = hasError);
    if (!hasError) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _sent ? _SuccessView(onBack: () => Navigator.pop(context)) : _FormView(
        nombreController: _nombreController,
        apellidoController: _apellidoController,
        telefonoController: _telefonoController,
        empresaController: _empresaController,
        cargoController: _cargoController,
        emailController: _emailController,
        mensajeController: _mensajeController,
        phoneCode: _phoneCode,
        phoneCodes: _phoneCodes,
        selectedCountry: _selectedCountry,
        emailError: _emailError,
        onPhoneCodeChanged: (v) => setState(() => _phoneCode = v),
        onCountryChanged: (p) => setState(() => _selectedCountry = p),
        onEmailChanged: (_) {
          if (_emailError) setState(() => _emailError = false);
        },
        onSubmit: _onSubmit,
      ),
    );
  }
}

// ─── Form View ────────────────────────────────────────────────────────────────

class _FormView extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final TextEditingController telefonoController;
  final TextEditingController empresaController;
  final TextEditingController cargoController;
  final TextEditingController emailController;
  final TextEditingController mensajeController;
  final String phoneCode;
  final List<({String code, String flag})> phoneCodes;
  final PaisModel? selectedCountry;
  final bool emailError;
  final ValueChanged<String> onPhoneCodeChanged;
  final ValueChanged<PaisModel?> onCountryChanged;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onSubmit;

  const _FormView({
    required this.nombreController,
    required this.apellidoController,
    required this.telefonoController,
    required this.empresaController,
    required this.cargoController,
    required this.emailController,
    required this.mensajeController,
    required this.phoneCode,
    required this.phoneCodes,
    required this.selectedCountry,
    required this.emailError,
    required this.onPhoneCodeChanged,
    required this.onCountryChanged,
    required this.onEmailChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _GradientHeader(),
          Transform.translate(
            offset: const Offset(0, -32),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _FormCard(
                    nombreController: nombreController,
                    apellidoController: apellidoController,
                    telefonoController: telefonoController,
                    empresaController: empresaController,
                    cargoController: cargoController,
                    emailController: emailController,
                    mensajeController: mensajeController,
                    phoneCode: phoneCode,
                    phoneCodes: phoneCodes,
                    selectedCountry: selectedCountry,
                    emailError: emailError,
                    onPhoneCodeChanged: onPhoneCodeChanged,
                    onCountryChanged: onCountryChanged,
                    onEmailChanged: onEmailChanged,
                    onSubmit: onSubmit,
                  ),
                  const SizedBox(height: 16),
                  const _SupportCard(),
                  const SizedBox(height: 16),
                  const _MapSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gradient Header ──────────────────────────────────────────────────────────

class _GradientHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top + 56;
    return Container(
      width: double.infinity,
      height: 220 + topPad,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Padding(
        padding: EdgeInsets.only(top: topPad),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Text(
                  'LC',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Contáctanos',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pronto un gerente regional se pondrá\nen contacto contigo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteTransparent,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Form Card ────────────────────────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final TextEditingController telefonoController;
  final TextEditingController empresaController;
  final TextEditingController cargoController;
  final TextEditingController emailController;
  final TextEditingController mensajeController;
  final String phoneCode;
  final List<({String code, String flag})> phoneCodes;
  final PaisModel? selectedCountry;
  final bool emailError;
  final ValueChanged<String> onPhoneCodeChanged;
  final ValueChanged<PaisModel?> onCountryChanged;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onSubmit;

  const _FormCard({
    required this.nombreController,
    required this.apellidoController,
    required this.telefonoController,
    required this.empresaController,
    required this.cargoController,
    required this.emailController,
    required this.mensajeController,
    required this.phoneCode,
    required this.phoneCodes,
    required this.selectedCountry,
    required this.emailError,
    required this.onPhoneCodeChanged,
    required this.onCountryChanged,
    required this.onEmailChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre + Apellido
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppFormField(
                  label: 'Nombre',
                  hint: 'Ej. Juan',
                  controller: nombreController,
                  prefixIcon: Icons.person_outline_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppFormField(
                  label: 'Apellido',
                  hint: 'Ej. Pérez',
                  controller: apellidoController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Teléfono + País
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Teléfono', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Row(
                    children: [
                      _PhoneCodeDropdown(
                        value: phoneCode,
                        codes: phoneCodes,
                        onChanged: onPhoneCodeChanged,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppFormField(
                          hint: '300 000 0000',
                          controller: telefonoController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('País', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    AppCountryDropdown(
                      value: selectedCountry,
                      onChanged: onCountryChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Empresa + Cargo
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppFormField(
                  label: 'Nombre de la empresa',
                  hint: 'Ej. LC Corp',
                  controller: empresaController,
                  prefixIcon: Icons.apartment_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppFormField(
                  label: 'Cargo',
                  hint: 'Ej. Director',
                  controller: cargoController,
                  prefixIcon: Icons.work_outline_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppFormField(
            label: 'Correo electrónico',
            hint: 'usuario@ejemplo.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            hasError: emailError,
            errorText: 'Por favor ingresa un correo electrónico válido',
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: 16),
          AppFormField(
            label: '¿En qué podemos ayudarte?',
            hint: 'Escribe tu mensaje aquí...',
            controller: mensajeController,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          // Submit
          GestureDetector(
            onTap: onSubmit,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enviar mensaje',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.send_rounded, color: AppColors.white, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.inputBorder),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latinoamérica Comparte',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Conectando regiones, transformando vidas.',
                    style: TextStyle(color: AppColors.textHint, fontSize: 11),
                  ),
                ],
              ),
              Row(
                children: [
                  _FooterIconBtn(icon: Icons.share_outlined),
                  const SizedBox(width: 8),
                  _FooterIconBtn(icon: Icons.help_outline_rounded),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Support Card ─────────────────────────────────────────────────────────────

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.metricDraftBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.support_agent_rounded,
                color: AppColors.primaryPurple, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atención Personalizada',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Nuestro equipo en Colombia, Chile y Ecuador está listo para apoyarte.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Map Section ──────────────────────────────────────────────────────────────

class _MapSection extends StatelessWidget {
  const _MapSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.metricInactiveBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(Icons.map_outlined,
                color: AppColors.inputBorder, size: 64),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Colombia · Chile · Ecuador',
                  style: TextStyle(
                    color: AppColors.textHint.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Success View ─────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  final VoidCallback onBack;
  const _SuccessView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.statusPublishedBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.statusPublishedText, size: 44),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Mensaje enviado!',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pronto un gerente regional\nse pondrá en contacto contigo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Volver',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _LabeledField, _FilledInput, _CountryDropdown → reemplazados por AppFormField y AppCountryDropdown

class _PhoneCodeDropdown extends StatelessWidget {
  final String value;
  final List<({String code, String flag})> codes;
  final ValueChanged<String> onChanged;

  const _PhoneCodeDropdown({
    required this.value,
    required this.codes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.formBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: codes.map((c) {
            return DropdownMenuItem<String>(
              value: c.code,
              child: Text('${c.flag} ${c.code}',
                  style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          onChanged: (v) => onChanged(v!),
          icon: const Icon(Icons.expand_more_rounded,
              color: AppColors.textHint, size: 16),
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          style:
              const TextStyle(color: AppColors.textPrimary, fontSize: 12),
        ),
      ),
    );
  }
}

class _FooterIconBtn extends StatelessWidget {
  final IconData icon;
  const _FooterIconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.metricDraftBg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primaryPurple, size: 18),
    );
  }
}
