// lib/pages/admin_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/supabase_provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController stockCtrl = TextEditingController();

  bool available = true;
  bool _loading = false;
  List<dynamic> ingredientes = [];

  @override
  void initState() {
    super.initState();
    _loadIngredientes();
  }

  Future<void> _loadIngredientes() async {
    setState(() => _loading = true);

    final supabase = context.read<SupabaseProvider>().client;

    final data = await supabase
        .from('ingredients')
        .select()
        .order('id', ascending: true);

    setState(() {
      ingredientes = data;
      _loading = false;
    });
  }

  Future<void> _addIngrediente() async {
    if (nameCtrl.text.trim().isEmpty ||
        priceCtrl.text.trim().isEmpty ||
        stockCtrl.text.trim().isEmpty) return;

    final supabase = context.read<SupabaseProvider>().client;

    await supabase.from('ingredients').insert({
      'name': nameCtrl.text.trim(),
      'price': double.tryParse(priceCtrl.text.trim()) ?? 0.0,
      'stock': int.tryParse(stockCtrl.text.trim()) ?? 0,
      'available': available,
    });

    nameCtrl.clear();
    priceCtrl.clear();
    stockCtrl.clear();
    available = true;

    _loadIngredientes();
  }

  Future<void> _deleteIngrediente(int id) async {
    final supabase = context.read<SupabaseProvider>().client;
    await supabase.from('ingredients').delete().eq('id', id);
    _loadIngredientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        title: const Text("Administrador"),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ------------------------------------------------
            //  CARD — AGREGAR INGREDIENTE
            // ------------------------------------------------
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Agregar Ingrediente",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Nombre
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Precio
                    TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Precio",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Stock
                    TextField(
                      controller: stockCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Stock",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Disponible
                    SwitchListTile(
                      value: available,
                      title: const Text("Disponible"),
                      activeColor: Colors.deepOrange,
                      onChanged: (val) {
                        setState(() => available = val);
                      },
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Agregar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _addIngrediente,
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------
            //  LISTA DE INGREDIENTES
            // ------------------------------------------------
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ingredientes.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay ingredientes",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: ingredientes.length,
                          itemBuilder: (context, i) {
                            final ing = ingredientes[i];

                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.fastfood,
                                    color: Colors.deepOrange),
                                title: Text(
                                  ing['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "S/ ${ing['price']}   |   Stock: ${ing['stock']}   |   ${ing['available'] ? 'Disponible' : 'No disponible'}",
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () =>
                                      _deleteIngrediente(ing['id']),
                                ),
                              ),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}
