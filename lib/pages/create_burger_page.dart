import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateBurgerPage extends StatefulWidget {
  const CreateBurgerPage({super.key});

  @override
  State<CreateBurgerPage> createState() => _CreateBurgerPageState();
}

class _CreateBurgerPageState extends State<CreateBurgerPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> ingredients = [];
  List<int> selectedIngredientIds = [];

  double basePrice = 10.00;  
  double totalPrice = 10.00;

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    final response = await supabase
        .from('ingredients')
        .select()
        .order('name', ascending: true);

    setState(() {
      ingredients = List<Map<String, dynamic>>.from(response);
    });
  }

  void toggleIngredient(Map<String, dynamic> ingredient, bool selected) {
    final ingId = ingredient['id'];
    final price = ingredient['price'] * 1.0;

    setState(() {
      if (selected) {
        selectedIngredientIds.add(ingId);
        totalPrice += price;
      } else {
        selectedIngredientIds.remove(ingId);
        totalPrice -= price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear mi hamburguesa"),
      ),
      body: ingredients.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ingredientes extras",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Expanded(
                    child: ListView.builder(
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        final ing = ingredients[index];
                        final ingId = ing['id'];
                        final price = (ing['price'] as num).toDouble();

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              "${ing['name']} (\$${price.toStringAsFixed(2)})",
                              style: const TextStyle(fontSize: 16),
                            ),
                            value: selectedIngredientIds.contains(ingId),
                            onChanged: (value) {
                              toggleIngredient(ing, value!);
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      padding: const EdgeInsets.symmetric(
          horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "🍔 ¡Tu hamburguesa fue creada exitosamente!",
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    },
    child: const Text(
      "Confirmar hamburguesa 🍔",
      style: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

                  const SizedBox(height: 15),

                  Text(
                    "Precio actual: \$${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
