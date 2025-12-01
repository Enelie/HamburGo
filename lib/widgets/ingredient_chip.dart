import 'package:flutter/material.dart';

/// Chip para mostrar un ingrediente con nombre, precio y cantidad seleccionada.
/// Uso: IngredientChip(
///   name: ing.name,
///   price: ing.price,
///   selected: isSelected,
///   qty: selectedQty,
///   onToggle: () => ...,
///   onQtyChanged: (newQty) => ...
/// )
class IngredientChip extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final bool selected;
  final int qty;
  final VoidCallback? onToggle;
  final ValueChanged<int>? onQtyChanged;

  const IngredientChip({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    this.selected = false,
    this.qty = 0,
    this.onToggle,
    this.onQtyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        onTap: onToggle,
        leading: CircleAvatar(
          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
          backgroundColor: selected ? Colors.greenAccent.shade700 : Colors.grey.shade800,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('S/ ${price.toStringAsFixed(2)}'),
        trailing: SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (selected) ...[
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: qty > 1
                      ? () => onQtyChanged?.call(qty - 1)
                      : () => onQtyChanged?.call(0),
                ),
                Text('$qty', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => onQtyChanged?.call(qty + 1),
                ),
              ] else
                ElevatedButton(
                  onPressed: onToggle,
                  child: const Text('Agregar'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
