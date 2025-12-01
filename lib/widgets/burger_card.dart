import 'package:flutter/material.dart';

/// Tarjeta simple para mostrar una hamburguesa (nombre, precio, extras).
/// Uso: BurgerCard(title: 'Mi Burger', subtitle: 'Extras: Queso, Bacon', price: 9.5)
class BurgerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double price;
  final VoidCallback? onTap;
  final Widget? leading;

  const BurgerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 6, offset: const Offset(0,4))
          ],
        ),
        child: Row(
          children: [
            if (leading != null)
              Padding(padding: const EdgeInsets.only(right: 12), child: leading),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text('S/ ${price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
