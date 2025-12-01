import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final orders = app.orders;
    return Scaffold(
      appBar: AppBar(title: const Text('Repartidor')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx,i){
          final o = orders[i];
          return ListTile(
            title: Text('Pedido ${o.id}'),
            subtitle: Text('Status: ${o.status}'),
            trailing: PopupMenuButton<String>(
              onSelected: (v) {
                // simulated status update
                o.status == 'pending';
                // In MVP we don't mutate Order fields directly; in real app implement repo.updateOrder
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marcar: $v (simulado)')));
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'delivered', child: Text('Entregado')),
                const PopupMenuItem(value: 'incident', child: Text('Registrar incidencia')),
              ],
            ),
          );
        },
      ),
    );
  }
}
