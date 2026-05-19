import 'package:app/core/app/app_colors.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormularioTestimoniosPage extends StatefulWidget {
  const FormularioTestimoniosPage({super.key});

  @override
  State<FormularioTestimoniosPage> createState() => _FormularioTestimoniosPageState();
}

class _FormularioTestimoniosPageState extends State<FormularioTestimoniosPage> {
  final _api = ApiService();
  final _nameController = TextEditingController();
  final _photoController = TextEditingController();
  final _textController = TextEditingController();
  final _countryController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  bool _isLoading = false;
  String _error = '';
  Map<String, dynamic>? _editing;
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    final country = prefs.getString('country') ?? '';
    setState(() { _role = role; });
    if (role != 'superadmin') _countryController.text = country;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && _editing == null) {
      _editing = args as Map<String, dynamic>;
      _nameController.text = _editing!['name'] ?? '';
      _photoController.text = _editing!['photo'] ?? '';
      _textController.text = _editing!['text'] ?? '';
      _countryController.text = _editing!['country'] ?? '';
      _instagramController.text = _editing!['instagram'] ?? '';
      _facebookController.text = _editing!['facebook'] ?? '';
    }
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty || _textController.text.isEmpty ||
        _photoController.text.isEmpty || _countryController.text.isEmpty) {
      setState(() => _error = 'Completa los campos obligatorios');
      return;
    }
    setState(() { _isLoading = true; _error = ''; });

    final body = {
      'name': _nameController.text,
      'photo': _photoController.text,
      'text': _textController.text,
      'country': _countryController.text,
      if (_instagramController.text.isNotEmpty) 'instagram': _instagramController.text,
      if (_facebookController.text.isNotEmpty) 'facebook': _facebookController.text,
    };

    bool ok;
    if (_editing != null) {
      ok = await _api.updateTestimonio(_editing!['_id'], body);
    } else {
      ok = await _api.createTestimonio(body);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _error = 'Error guardando testimonio');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editing != null;
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'Editar testimonio' : 'Nuevo testimonio',
            style: const TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Field(label: 'Nombre *', controller: _nameController),
            _Field(label: 'URL de foto *', controller: _photoController),
            _Field(label: 'Testimonio *', controller: _textController, maxLines: 4),
            _Field(
              label: 'País *',
              controller: _countryController,
              enabled: _role == 'superadmin',
            ),
            _Field(label: 'Instagram (opcional)', controller: _instagramController),
            _Field(label: 'Facebook (opcional)', controller: _facebookController),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_error, style: const TextStyle(color: AppColors.errorColor)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : Text(isEditing ? 'Guardar cambios' : 'Crear testimonio',
                        style: const TextStyle(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final bool enabled;

  const _Field({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}