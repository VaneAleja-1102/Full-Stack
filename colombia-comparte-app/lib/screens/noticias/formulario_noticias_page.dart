import 'package:app/core/app/app_colors.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormularioNoticiasPage extends StatefulWidget {
  const FormularioNoticiasPage({super.key});

  @override
  State<FormularioNoticiasPage> createState() => _FormularioNoticiasPageState();
}

class _FormularioNoticiasPageState extends State<FormularioNoticiasPage> {
  final _api = ApiService();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _contentController = TextEditingController();
  final _countryController = TextEditingController();
  final _authorController = TextEditingController();
  final _imageController = TextEditingController();
  String _status = 'borrador';
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
    final name = prefs.getString('name') ?? '';
    setState(() { _role = role; });
    if (role != 'superadmin') {
      _countryController.text = country;
      _authorController.text = name;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && _editing == null) {
      _editing = args as Map<String, dynamic>;
      _titleController.text = _editing!['title'] ?? '';
      _summaryController.text = _editing!['summary'] ?? '';
      _contentController.text = _editing!['content'] ?? '';
      _countryController.text = _editing!['country'] ?? '';
      _authorController.text = _editing!['author'] ?? '';
      _imageController.text = _editing!['imageUrl'] ?? '';
      _status = _editing!['status'] ?? 'borrador';
    }
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty || _summaryController.text.isEmpty ||
        _contentController.text.isEmpty || _countryController.text.isEmpty ||
        _authorController.text.isEmpty) {
      setState(() => _error = 'Completa los campos obligatorios');
      return;
    }
    setState(() { _isLoading = true; _error = ''; });

    final body = {
      'title': _titleController.text,
      'summary': _summaryController.text,
      'content': _contentController.text,
      'country': _countryController.text,
      'author': _authorController.text,
      'status': _status,
      if (_imageController.text.isNotEmpty) 'imageUrl': _imageController.text,
    };

    bool ok;
    if (_editing != null) {
      ok = await _api.updateNoticia(_editing!['_id'], body);
    } else {
      ok = await _api.createNoticia(body);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _error = 'Error guardando noticia');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editing != null;
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'Editar noticia' : 'Nueva noticia',
            style: const TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Field(label: 'Título *', controller: _titleController),
            _Field(label: 'Resumen *', controller: _summaryController, maxLines: 2),
            _Field(label: 'Contenido *', controller: _contentController, maxLines: 5),
            _Field(label: 'País *', controller: _countryController, enabled: _role == 'superadmin'),
            _Field(label: 'Autor *', controller: _authorController),
            _Field(label: 'URL imagen (opcional)', controller: _imageController),
            const SizedBox(height: 8),
            const Text('Estado', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatusChip(
                  label: 'Borrador',
                  selected: _status == 'borrador',
                  onTap: () => setState(() => _status = 'borrador'),
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  label: 'Publicado',
                  selected: _status == 'publicado',
                  onTap: () => setState(() => _status = 'publicado'),
                ),
              ],
            ),
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
                    : Text(isEditing ? 'Guardar cambios' : 'Crear noticia',
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

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryPurple : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryPurple),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.white : AppColors.primaryPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}