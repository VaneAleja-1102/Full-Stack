import 'package:app/core/app/app_colors.dart';
import 'package:app/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPortalsPage extends StatefulWidget {
  const AllPortalsPage({super.key});

  @override
  State<AllPortalsPage> createState() => _AllPortalsPageState();
}

class _AllPortalsPageState extends State<AllPortalsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CountryProvider>().loadCountries();
    });
  }

  Future<void> _confirmDelete(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar país'),
        content: Text('¿Estás seguro de eliminar $name?'),
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
      context.read<CountryProvider>().deleteCountry(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CountryProvider>();
    return Scaffold(
      backgroundColor: AppColors.formBackground,
      appBar: AppBar(
        title: const Text('Portales', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error.isNotEmpty
              ? Center(child: Text(provider.error, style: const TextStyle(color: Colors.red)))
              : RefreshIndicator(
                  onRefresh: () => context.read<CountryProvider>().loadCountries(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.countries.length,
                    itemBuilder: (context, index) {
                      final c = provider.countries[index];
                      final isActive = c['status'] == 'active';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(c['flag'] ?? '🌍', style: const TextStyle(fontSize: 32)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c['name'],
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text(c['code'],
                                        style: const TextStyle(color: AppColors.textSecondary)),
                                    if (c['domain'] != null)
                                      Text(c['domain'],
                                          style: const TextStyle(
                                              color: AppColors.primaryPurple, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isActive ? AppColors.statusPublishedBg : AppColors.metricInactiveBg,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isActive ? 'Activo' : 'Inactivo',
                                      style: TextStyle(
                                        color: isActive ? AppColors.statusPublishedText : AppColors.metricInactiveText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => context
                                            .read<CountryProvider>()
                                            .toggleStatus(c['_id'], c['status']),
                                        child: Icon(
                                          isActive ? Icons.toggle_on : Icons.toggle_off,
                                          color: isActive ? AppColors.statusPublishedText : AppColors.textHint,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => _confirmDelete(c['_id'], c['name']),
                                        child: const Icon(Icons.delete_outline,
                                            color: AppColors.errorColor, size: 22),
                                      ),
                                    ],
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