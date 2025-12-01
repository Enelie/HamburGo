import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'receipt_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduled = ModalRoute.of(context)!.settings.arguments as DateTime?;
    final app = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Total: S/ ${app.currentPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Pago simulado (tarjeta)'),
              subtitle: const Text('No se realizará cobro real'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final order = await app.placeOrder(scheduled: scheduled);
                // Simula pago y continua a recibo
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReceiptPage(orderId: order.id)));
              },
              child: const Text('Pagar y Confirmar Pedido'),
            )
          ],
        ),
      ),
    );
  }
}
