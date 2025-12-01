import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HamburGo - Menú')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/editor'),
            child: const Text('Crear mi hamburguesa'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
            child: const Text('Ver pedido'),
          ),
        ],
      ),
    );
  }
}
