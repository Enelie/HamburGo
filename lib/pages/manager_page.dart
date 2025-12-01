import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ManagerPage extends StatelessWidget {
  const ManagerPage({super.key});
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final ing = app.ingredients;
    return Scaffold(
      appBar: AppBar(title: const Text('Gerente')),
      body: ListView(
        children: ing.map((i) => SwitchListTile(
          title: Text(i.name),
          subtitle: Text('Disponible: ${i.available}'),
          value: i.available,
          onChanged: (v) {
            final updated = i..available = v;
            app.updateIngredient(updated);
          },
        )).toList(),
      ),
    );
  }
}
