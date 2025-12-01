import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/ingredient.dart';
import 'package:uuid/uuid.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final ing = app.ingredients;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Ingredientes')),
      body: ListView.builder(
        itemCount: ing.length,
        itemBuilder: (ctx,i){
          final it = ing[i];
          return ListTile(
            title: Text(it.name),
            subtitle: Text('Precio S/ ${it.price} - Stock: ${it.stock} - ${it.available ? 'Disponible' : 'No disponible'}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editDialog(context, app, it),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addDialog(context, app),
      ),
    );
  }

  void _editDialog(BuildContext ctx, AppProvider app, Ingredient ing) {
    final nameC = TextEditingController(text: ing.name);
    final priceC = TextEditingController(text: ing.price.toString());
    final stockC = TextEditingController(text: ing.stock.toString());
    bool available = ing.available;
    showDialog(context: ctx, builder: (c){
      return AlertDialog(
        title: const Text('Editar ingrediente'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Nombre')),
          TextField(controller: priceC, decoration: const InputDecoration(labelText: 'Precio')),
          TextField(controller: stockC, decoration: const InputDecoration(labelText: 'Stock')),
          SwitchListTile(title: const Text('Disponible'), value: available, onChanged: (v){ available = v; }),
        ]),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(c), child: const Text('Cancelar')),
          TextButton(onPressed: () {
            final updated = Ingredient(id: ing.id, name: nameC.text, price: double.tryParse(priceC.text) ?? ing.price, stock: int.tryParse(stockC.text) ?? ing.stock, available: available);
            app.updateIngredient(updated);
            Navigator.pop(c);
          }, child: const Text('Guardar')),
        ],
      );
    });
  }

  void _addDialog(BuildContext ctx, AppProvider app) {
    final nameC = TextEditingController();
    final priceC = TextEditingController();
    final stockC = TextEditingController();
    showDialog(context: ctx, builder: (c){
      return AlertDialog(
        title: const Text('Agregar ingrediente'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Nombre')),
          TextField(controller: priceC, decoration: const InputDecoration(labelText: 'Precio')),
          TextField(controller: stockC, decoration: const InputDecoration(labelText: 'Stock')),
        ]),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(c), child: const Text('Cancelar')),
          TextButton(onPressed: () {
            final newIng = Ingredient(id: const Uuid().v4(), name: nameC.text, price: double.tryParse(priceC.text) ?? 0.0, stock: int.tryParse(stockC.text) ?? 0);
            app.updateIngredient(newIng);
            Navigator.pop(c);
          }, child: const Text('Agregar')),
        ],
      );
    });
  }
}
