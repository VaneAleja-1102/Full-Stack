import 'package:app/core/app/app_colors.dart';
import 'package:app/models/pais_model.dart';
import 'package:flutter/material.dart';

/// Dropdown de selección de país usando la lista de [paisesMock].
class AppCountryDropdown extends StatelessWidget {
  final PaisModel? value;
  final ValueChanged<PaisModel?> onChanged;
  final String hint;

  const AppCountryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint = 'Selecciona un país',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.formBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PaisModel>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.textHint, fontSize: 14),
          ),
          items: paisesMock.map((p) {
            return DropdownMenuItem<PaisModel>(
              value: p,
              child: Row(
                children: [
                  Text(p.flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Text(
                    p.name,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.expand_more_rounded,
              color: AppColors.textHint, size: 20),
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
