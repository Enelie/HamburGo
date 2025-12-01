import 'package:flutter/material.dart';
import 'package:peliculas/models/burger.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/ingredient.dart';

class CreateBurgerPage extends StatefulWidget {
  const CreateBurgerPage({super.key});

  @override
  State<CreateBurgerPage> createState() => _CreateBurgerPageState();
}

class _CreateBurgerPageState extends State<CreateBurgerPage> {
  // Ingredientes seleccionados
  final Map<String, bool> selectedExtras = {};

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    // Si no hay currentBurger inicializamos
    provider.currentBurger ??= provider.currentBurger = provider.currentBurger ??
        Burger(id: 'local', name: 'Mi Hamburguesa', basePrice: 5.0);

    final ingredients = provider.ingredients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear mi hamburguesa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ingredientes extras", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...ingredients.map((ing) {
              selectedExtras[ing.id] ??= false;
              return CheckboxListTile(
                title: Text("${ing.name} (\$${ing.price.toStringAsFixed(2)})"),
                value: selectedExtras[ing.id],
                onChanged: (v) {
                  setState(() {
                    selectedExtras[ing.id] = v ?? false;
                    if (v == true) {
                      provider.currentBurger!.extras[ing.id] = 1;
                    } else {
                      provider.currentBurger!.extras.remove(ing.id);
                    }
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Confirmar hamburguesa local
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hamburguesa creada! 🍔'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Confirmar hamburguesa 🍔",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Precio actual: \$${provider.currentPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
