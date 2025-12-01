import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/review.dart';
import 'package:uuid/uuid.dart';

class ReceiptPage extends StatelessWidget {
  final String orderId;
  const ReceiptPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final order = app.orders.lastWhere((o) => o.id == orderId);
    return Scaffold(
      appBar: AppBar(title: const Text('Recibo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Pedido: ${order.id}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Total: S/ ${app.currentPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
            Text('Programado: ${order.scheduledAt?.toLocal().toString() ?? 'En entrega inmediata'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Valorar pedido'),
              onPressed: () => _showReviewDialog(context, app, order.id),
            ),
            const Spacer(),
            ElevatedButton(
              child: const Text('Volver al inicio'),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext ctx, AppProvider app, String orderId) {
    final _controller = TextEditingController();
    int rating = 5;
    showDialog(context: ctx, builder: (c){
      return AlertDialog(
        title: const Text('Deja una reseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(builder: (bc, setState){
              return Row(
                children: List.generate(5, (i){
                  return IconButton(
                    icon: Icon(i < rating ? Icons.star : Icons.star_border, color: Colors.amber),
                    onPressed: () => setState(() => rating = i+1),
                  );
                }),
              );
            }),
            TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Comentario')),
          ],
        ),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(c), child: const Text('Cancelar')),
          TextButton(onPressed: (){
            final rev = Review(id: const Uuid().v4(), orderId: orderId, rating: rating, comment: _controller.text, date: DateTime.now());
            app.addReview(rev);
            Navigator.pop(c);
            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Reseña guardada')));
          }, child: const Text('Enviar'))
        ],
      );
    });
  }
}
