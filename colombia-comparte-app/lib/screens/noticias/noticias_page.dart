import 'package:app/core/app/app_colors.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  State<NoticiasPage> createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  final _api = ApiService();
  List<dynamic> _noticias = [];
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
      final data = await _api.getNoticias();
      setState(() { _noticias = data; _isLoading = false; });
    } catch (e) {
      setState(() { _error = 'Error cargando noticias'; _isLoading = false; });
    }
  }

  Future<void> _toggleStatus(String id, String current) async {
    final newStatus = current == 'publicado' ? 'borrador' : 'publicado';
    await _api.updateNoticiaStatus(id, newStatus);
    _load();
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar noticia'),
        content: const Text('¿Estás seguro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await _api.deleteNoticia(id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: AppBar(
        title: const Text('Noticias', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPurple,
        onPressed: () => Navigator.pushNamed(context, '/noticias/nuevo').then((_) => _load()),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
              : _noticias.isEmpty
                  ? const Center(child: Text('No hay noticias'))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _noticias.length,
                        itemBuilder: (context, index) {
                          final n = _noticias[index];
                          final status = n['status'] ?? 'borrador';
                          final isPublished = status == 'publicado';
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
                                        child: Text(n['title'],
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isPublished ? AppColors.statusPublishedBg : AppColors.statusDraftBg,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(status,
                                            style: TextStyle(
                                              color: isPublished ? AppColors.statusPublishedText : AppColors.statusDraftText,
                                              fontSize: 11,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text('${n['author']} · ${n['country']}',
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Text(n['summary'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: AppColors.textPrimary)),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => _toggleStatus(n['_id'], status),
                                        icon: Icon(isPublished ? Icons.visibility_off : Icons.visibility, size: 16),
                                        label: Text(isPublished ? 'Despublicar' : 'Publicar'),
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.pushNamed(
                                          context, '/noticias/nuevo',
                                          arguments: n,
                                        ).then((_) => _load()),
                                        icon: const Icon(Icons.edit_outlined, color: AppColors.primaryPurple),
                                      ),
                                      IconButton(
                                        onPressed: () => _confirmDelete(n['_id']),
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