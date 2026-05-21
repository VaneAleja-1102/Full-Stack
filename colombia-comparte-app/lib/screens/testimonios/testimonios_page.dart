import 'package:app/core/app/app_colors.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/providers/testimonio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestimoniosPage extends StatefulWidget {
  const TestimoniosPage({super.key});

  @override
  State<TestimoniosPage> createState() => _TestimoniosPageState();
}

class _TestimoniosPageState extends State<TestimoniosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TestimonioProvider>().loadTestimonios();
    });
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar testimonio'),
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
      context.read<TestimonioProvider>().deleteTestimonio(id);
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
    final provider = context.watch<TestimonioProvider>();
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: AppBar(
        title: const Text('Testimonios', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      floatingActionButton: auth.isEditor
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.primaryPurple,
              onPressed: () => Navigator.pushNamed(context, '/testimonios/nuevo')
                  .then((_) => context.read<TestimonioProvider>().loadTestimonios()),
              child: const Icon(Icons.add, color: AppColors.white),
            ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error.isNotEmpty
              ? Center(child: Text(provider.error, style: const TextStyle(color: Colors.red)))
              : provider.testimonios.isEmpty
                  ? const Center(child: Text('No hay testimonios'))
                  : RefreshIndicator(
                      onRefresh: () => context.read<TestimonioProvider>().loadTestimonios(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.testimonios.length,
                        itemBuilder: (context, index) {
                          final t = provider.testimonios[index];
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
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 16)),
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
                                  Text(t['country'],
                                      style: const TextStyle(color: AppColors.textSecondary)),
                                  const SizedBox(height: 8),
                                  Text(t['text'],
                                      maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (!auth.isEditor)
                                        TextButton.icon(
                                          onPressed: () => context
                                              .read<TestimonioProvider>()
                                              .toggleStatus(t['_id'], status),
                                          icon: Icon(
                                            status == 'publicado'
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            size: 16,
                                          ),
                                          label: Text(status == 'publicado'
                                              ? 'Despublicar'
                                              : 'Publicar'),
                                        ),
                                      if (!auth.isEditor) ...[
                                        IconButton(
                                          onPressed: () => Navigator.pushNamed(
                                            context,
                                            '/testimonios/nuevo',
                                            arguments: t,
                                          ).then((_) => context
                                              .read<TestimonioProvider>()
                                              .loadTestimonios()),
                                          icon: const Icon(Icons.edit_outlined,
                                              color: AppColors.primaryPurple),
                                        ),
                                        IconButton(
                                          onPressed: () => _confirmDelete(t['_id']),
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