import 'package:flutter/material.dart';

class PedidoEnviadoScreen extends StatelessWidget {
  final String numeroPedido;

  const PedidoEnviadoScreen({
    super.key,
    required this.numeroPedido,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 110,
                ),

                const SizedBox(height: 25),

                const Text(
                  'Pedido enviado correctamente',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'El pedido fue recibido por cocina.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  numeroPedido,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        true,
                      );
                    },
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}