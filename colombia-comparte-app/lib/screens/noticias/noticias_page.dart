import 'package:app/core/app/app_colors.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/providers/noticia_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  State<NoticiasPage> createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticiaProvider>().loadNoticias();
    });
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar noticia'),
        content: const Text('¿Estás seguro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<NoticiaProvider>().deleteNoticia(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoticiaProvider>();
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: AppBar(
        title: const Text('Noticias', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      floatingActionButton: auth.isEditor
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.primaryPurple,
              onPressed: () => Navigator.pushNamed(context, '/noticias/nuevo')
                  .then((_) => context.read<NoticiaProvider>().loadNoticias()),
              child: const Icon(Icons.add, color: AppColors.white),
            ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error.isNotEmpty
              ? Center(child: Text(provider.error, style: const TextStyle(color: Colors.red)))
              : provider.noticias.isEmpty
                  ? const Center(child: Text('No hay noticias'))
                  : RefreshIndicator(
                      onRefresh: () => context.read<NoticiaProvider>().loadNoticias(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.noticias.length,
                        itemBuilder: (context, index) {
                          final n = provider.noticias[index];
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
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 15)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isPublished
                                              ? AppColors.statusPublishedBg
                                              : AppColors.statusDraftBg,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(status,
                                            style: TextStyle(
                                              color: isPublished
                                                  ? AppColors.statusPublishedText
                                                  : AppColors.statusDraftText,
                                              fontSize: 11,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text('${n['author']} · ${n['country']}',
                                      style: const TextStyle(
                                          color: AppColors.textSecondary, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Text(n['summary'],
                                      maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (!auth.isEditor)
                                        TextButton.icon(
                                          onPressed: () => context
                                              .read<NoticiaProvider>()
                                              .toggleStatus(n['_id'], status),
                                          icon: Icon(
                                              isPublished
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              size: 16),
                                          label: Text(isPublished ? 'Despublicar' : 'Publicar'),
                                        ),
                                      if (!auth.isEditor) ...[
                                        IconButton(
                                          onPressed: () => Navigator.pushNamed(
                                            context,
                                            '/noticias/nuevo',
                                            arguments: n,
                                          ).then((_) =>
                                              context.read<NoticiaProvider>().loadNoticias()),
                                          icon: const Icon(Icons.edit_outlined,
                                              color: AppColors.primaryPurple),
                                        ),
                                        IconButton(
                                          onPressed: () => _confirmDelete(n['_id']),
                                          icon: const Icon(Icons.delete_outline,
                                              color: AppColors.errorColor),
                                        ),
                                      ],
                                      if (auth.isEditor)
                                        const Text('Solo lectura',
                                            style: TextStyle(
                                                color: AppColors.textHint, fontSize: 12)),
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