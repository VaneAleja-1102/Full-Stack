import 'package:app/core/app/app_colors.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/providers/solicitud_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestDetailsPage extends StatefulWidget {
  const RequestDetailsPage({super.key});

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  bool _isUpdating = false;

  Future<void> _updateStatus(String id, String status) async {
    setState(() => _isUpdating = true);
    final ok = await context.read<SolicitudProvider>().updateStatus(id, status);
    if (!mounted) return;
    setState(() => _isUpdating = false);
    if (ok) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final s = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final status = s['status'] ?? 'pendiente';
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: AppBar(
        title: const Text('Detalle solicitud', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: 'Nombre', value: s['name'] ?? ''),
                    _DetailRow(label: 'Correo', value: s['email'] ?? ''),
                    _DetailRow(label: 'Teléfono', value: s['phone'] ?? ''),
                    _DetailRow(label: 'País', value: s['country'] ?? ''),
                    _DetailRow(label: 'Finalidad', value: s['finalidad'] ?? ''),
                    _DetailRow(label: 'Estado', value: s['status'] ?? ''),
                    const SizedBox(height: 8),
                    const Text('Mensaje',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(s['message'] ?? ''),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Solo admin_pais y superadmin pueden cambiar estado
            if (!auth.isEditor) ...[
              const Text('Cambiar estado',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              if (_isUpdating)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    if (status == 'pendiente')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateStatus(s['_id'], 'gestionada'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.statusManagedText),
                          child: const Text('Marcar gestionada',
                              style: TextStyle(color: AppColors.white)),
                        ),
                      ),
                    if (status == 'gestionada')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateStatus(s['_id'], 'respondida'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.statusPublishedText),
                          child: const Text('Marcar respondida',
                              style: TextStyle(color: AppColors.white)),
                        ),
                      ),
                    if (status == 'respondida')
                      const Expanded(
                        child: Center(child: Text('✅ Solicitud respondida')),
                      ),
                  ],
                ),
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.metricInactiveBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.textHint, size: 18),
                    SizedBox(width: 8),
                    Text('Solo lectura — no puedes cambiar el estado',
                        style: TextStyle(color: AppColors.textHint, fontSize: 13)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}