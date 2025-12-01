import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final orders = app.orders;
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Cocina')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i){
          final o = orders[i];
          return Card(
            child: ListTile(
              title: Text('Pedido ${o.id} - ${o.burger.name}'),
              subtitle: Text('Programado: ${o.scheduledAt?.toLocal().toString() ?? 'Hoy'}'),
              trailing: Text(o.status),
            ),
          );
        },
      ),
    );
  }
}
