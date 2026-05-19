import 'package:app/core/app/app_colors.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class TestimoniosPage extends StatefulWidget {
  const TestimoniosPage({super.key});

  @override
  State<TestimoniosPage> createState() => _TestimoniosPageState();
}

class _TestimoniosPageState extends State<TestimoniosPage> {
  final _api = ApiService();
  List<dynamic> _testimonios = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      setState(() { _isLoading = true; _error = ''; });
      final data = await _api.getTestimonios();
      setState(() { _testimonios = data; _isLoading = false; });
    } catch (e) {
      setState(() { _error = 'Error cargando testimonios'; _isLoading = false; });
    }
  }

  Future<void> _toggleStatus(String id, String current) async {
    final newStatus = current == 'publicado' ? 'despublicado' : 'publicado';
    await _api.updateTestimonioStatus(id, newStatus);
    _load();
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar testimonio'),
        content: const Text('¿Estás seguro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await _api.deleteTestimonio(id);
      _load();
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'publicado': return AppColors.statusPublishedText;
      case 'borrador': return AppColors.statusDraftText;
      case 'despublicado': return AppColors.statusUnpublishedText;
      default: return AppColors.textHint;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'publicado': return AppColors.statusPublishedBg;
      case 'borrador': return AppColors.statusDraftBg;
      case 'despublicado': return AppColors.statusUnpublishedBg;
      default: return AppColors.metricInactiveBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: AppBar(
        title: const Text('Testimonios', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPurple,
        onPressed: () => Navigator.pushNamed(context, '/testimonios/nuevo').then((_) => _load()),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
              : _testimonios.isEmpty
                  ? const Center(child: Text('No hay testimonios'))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _testimonios.length,
                        itemBuilder: (context, index) {
                          final t = _testimonios[index];
                          final status = t['status'] ?? 'borrador';
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(t['name'],
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _statusBg(status),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(status,
                                            style: TextStyle(color: _statusColor(status), fontSize: 11)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(t['country'], style: const TextStyle(color: AppColors.textSecondary)),
                                  const SizedBox(height: 8),
                                  Text(t['text'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: AppColors.textPrimary)),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => _toggleStatus(t['_id'], status),
                                        icon: Icon(
                                          status == 'publicado' ? Icons.visibility_off : Icons.visibility,
                                          size: 16,
                                        ),
                                        label: Text(status == 'publicado' ? 'Despublicar' : 'Publicar'),
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.pushNamed(
                                          context, '/testimonios/nuevo',
                                          arguments: t,
                                        ).then((_) => _load()),
                                        icon: const Icon(Icons.edit_outlined, color: AppColors.primaryPurple),
                                      ),
                                      IconButton(
                                        onPressed: () => _confirmDelete(t['_id']),
                                        icon: const Icon(Icons.delete_outline, color: AppColors.errorColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}