import 'package:peliculas/models/burger.dart';

class Order {
  final String id;
  final Burger burger;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final String status; // pending, preparing, enroute, delivered
  final String paymentMethod; // simulated

  Order({
    required this.id,
    required this.burger,
    required this.createdAt,
    this.scheduledAt,
    this.status = 'pending',
    this.paymentMethod = 'Simulado',
  });

  Map<String,dynamic> toMap() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'scheduledAt': scheduledAt?.toIso8601String(),
    'status': status,
  };
}
