import 'package:flutter/material.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C1C), Color(0xFF0E0E0E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "HamburGo 🍔",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Personaliza, revisa tu pedido y accede a opciones",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),

                const SizedBox(height: 30),

                //  CONTENEDOR PRINCIPAL
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          "https://www.lanacion.com.ar/resizer/v2/gentileza-RGDDRKNE2ZHJNB2M2DK5JKL5EI.jpg?auth=d7d321d78fbdd6400132aaa2839faea749c0c09ffda36ee52718f2642ee2117d&width=880&height=586&quality=70&smart=true",
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 18),
                      const Text(
                        "Crea tu hamburguesa con nuestros ingredientes frescos.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),

                      const SizedBox(height: 20),

                      // BOTÓN CREAR HAMBURGUESA
                      _bigButton(
                        context,
                        text: "Crear mi hamburguesa",
                        icon: Icons.restaurant_menu,
                        color: Colors.orangeAccent,
                        route: '/createBurger', // ya va al constructor real
                      ),

                      const SizedBox(height: 12),

                      // BOTÓN VER PEDIDO / CHECKOUT
                      _bigButton(
                        context,
                        text: "Ver mi pedido",
                        icon: Icons.receipt_long,
                        color: Colors.amber,
                        route: '/checkout',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //  GRID DE ACCIONES
                const Text(
                  "Otras acciones",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _smallButton(context, "Cocina", Icons.kitchen, '/kitchen'),
                      _smallButton(context, "Administrador", Icons.settings, '/admin'),
                      _smallButton(context, "Repartidor", Icons.delivery_dining, '/delivery'),
                      _smallButton(context, "Gerente", Icons.business_center, '/manager'),
                      _smallButton(context, "Reseñas", Icons.star_rate, '/reviews'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────
  // BOTÓN GRANDE
  // ─────────────────────────────
  Widget _bigButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
        ),
        onPressed: () => Navigator.pushNamed(context, route),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────
  // BOTONES PEQUEÑOS
  // ─────────────────────────────
  Widget _smallButton(
    BuildContext context,
    String text,
    IconData icon,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.22),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.orangeAccent),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
