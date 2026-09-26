import 'package:flutter/material.dart';
import '../../domain/entities/ask_type_entity.dart';
import 'ask_type_card.dart';

class AskTypesGrid extends StatelessWidget {
  final List<AskTypeEntity> types;
  final AskTypeEntity? selectedType;
  final void Function(AskTypeEntity type) onTypeTap;

  const AskTypesGrid({
    super.key,
    required this.types,
    this.selectedType,
    required this.onTypeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 54,
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        final isSelected = selectedType != null &&
            ((selectedType!.id.isNotEmpty && selectedType!.id == type.id) ||
                (selectedType!.code.isNotEmpty &&
                    selectedType!.code == type.code));
        return AskTypeCard(
          type: type,
          index: index,
          isSelected: isSelected,
          onTap: () => onTypeTap(type),
        );
      },
    );
  }
}
