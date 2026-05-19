import 'package:app/core/app/app_colors.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _api = ApiService();
  List<dynamic> _solicitudes = [];
  bool _isLoading = true;
  String _error = '';
  String? _filterStatus;
  String? _filterCountry;
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _role = prefs.getString('role') ?? '');
    _loadSolicitudes();
  }

  Future<void> _loadSolicitudes() async {
    try {
      setState(() { _isLoading = true; _error = ''; });
      final solicitudes = await _api.getSolicitudes(
        status: _filterStatus,
        country: _filterCountry,
      );
      setState(() { _solicitudes = solicitudes; _isLoading = false; });
    } catch (e) {
      setState(() { _error = 'Error cargando solicitudes'; _isLoading = false; });
    }
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar solicitud'),
        content: const Text('¿Estás seguro de eliminar esta solicitud?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final ok = await _api.deleteSolicitud(id);
      if (ok) _loadSolicitudes();
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pendiente': return AppColors.statusPendingText;
      case 'gestionada': return AppColors.statusManagedText;
      case 'respondida': return AppColors.statusPublishedText;
      default: return AppColors.textHint;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'pendiente': return AppColors.statusPendingBg;
      case 'gestionada': return AppColors.statusManagedBg;
      case 'respondida': return AppColors.statusPublishedBg;
      default: return AppColors.metricInactiveBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: AppBar(
        title: const Text('Solicitudes', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filterStatus,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Todos')),
                      DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                      DropdownMenuItem(value: 'gestionada', child: Text('Gestionada')),
                      DropdownMenuItem(value: 'respondida', child: Text('Respondida')),
                    ],
                    onChanged: (v) { setState(() => _filterStatus = v); _loadSolicitudes(); },
                  ),
                ),
                if (_role == 'superadmin') ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _filterCountry,
                      decoration: const InputDecoration(
                        labelText: 'País',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Todos')),
                        DropdownMenuItem(value: 'Colombia', child: Text('Colombia')),
                        DropdownMenuItem(value: 'Chile', child: Text('Chile')),
                        DropdownMenuItem(value: 'Ecuador', child: Text('Ecuador')),
                        DropdownMenuItem(value: 'México', child: Text('México')),
                      ],
                      onChanged: (v) { setState(() => _filterCountry = v); _loadSolicitudes(); },
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
                    : _solicitudes.isEmpty
                        ? const Center(child: Text('No hay solicitudes'))
                        : RefreshIndicator(
                            onRefresh: _loadSolicitudes,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _solicitudes.length,
                              itemBuilder: (context, index) {
                                final s = _solicitudes[index];
                                final status = s['status'] ?? 'pendiente';
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    title: Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(s['email']),
                                        Text('${s['country']} · ${s['finalidad']}',
                                            style: const TextStyle(color: AppColors.textSecondary)),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _statusBg(status),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(status,
                                              style: TextStyle(color: _statusColor(status), fontSize: 11)),
                                        ),
                                        if (_role != 'editor')
                                          GestureDetector(
                                            onTap: () => _confirmDelete(s['_id']),
                                            child: const Icon(Icons.delete_outline, color: AppColors.errorColor, size: 20),
                                          ),
                                      ],
                                    ),
                                    onTap: () => Navigator.pushNamed(
                                      context, '/solicitudes/detalle',
                                      arguments: s,
                                    ).then((_) => _loadSolicitudes()),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}