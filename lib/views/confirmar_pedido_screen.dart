import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/firebase_service.dart';
import 'pedido_enviado_screen.dart';

class ConfirmarPedidoScreen extends StatefulWidget {
  final String mesa;
  final String tipoPedido;
  final List<Producto> productos;
  final double total;

  const ConfirmarPedidoScreen({
    super.key,
    required this.mesa,
    required this.tipoPedido,
    required this.productos,
    required this.total,
  });

  @override
  State<ConfirmarPedidoScreen> createState() =>
      _ConfirmarPedidoScreenState();
}

class _ConfirmarPedidoScreenState
    extends State<ConfirmarPedidoScreen> {
  final FirebaseService firebaseService = FirebaseService();

  bool enviando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Confirmar pedido',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mesa
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.table_restaurant,
                              size: 30,
                            ),

                            const SizedBox(width: 10),

                            Text(
                              widget.mesa,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Productos',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Productos seleccionados
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.productos.length,
                      itemBuilder: (context, index) {
                        final Producto producto =
                        widget.productos[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: Text(
                              producto.emoji,
                              style: const TextStyle(
                                fontSize: 30,
                              ),
                            ),

                            title: Text(
                              producto.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              '${producto.cantidad} x \$${producto.precio.toStringAsFixed(2)}',
                            ),

                            trailing: Text(
                              '\$${producto.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Tipo de pedido
                    Card(
                      child: ListTile(
                        leading: Icon(
                          widget.tipoPedido == 'Comer aquí'
                              ? Icons.restaurant
                              : Icons.shopping_bag,
                        ),

                        title: const Text(
                          'Tipo de pedido',
                        ),

                        subtitle: Text(
                          widget.tipoPedido,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Total
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          '\$${widget.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Editar pedido
                    OutlinedButton.icon(
                      onPressed: enviando
                          ? null
                          : () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.edit,
                      ),
                      label: const Text(
                        'Editar pedido',
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Enviar pedido
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed:
                        enviando ? null : enviarPedido,
                        child: enviando
                            ? const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),

                            SizedBox(width: 12),

                            Text(
                              'Enviando pedido...',
                            ),
                          ],
                        )
                            : const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send,
                            ),

                            SizedBox(width: 8),

                            Text(
                              'Enviar pedido',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> enviarPedido() async {
    setState(() {
      enviando = true;
    });

    try {
      // Guardar pedido en Firebase
      final int numeroPedido =
      await firebaseService.guardarPedido(
        mesa: widget.mesa,
        tipoPedido: widget.tipoPedido,
        productos: widget.productos,
        total: widget.total,
      );

      if (!mounted) {
        return;
      }

      // Formato:
      // 1 -> 0001
      // 2 -> 0002
      // 25 -> 0025
      final String numeroFormateado =
      numeroPedido.toString().padLeft(
        4,
        '0',
      );

      // Mostrar pantalla de pedido enviado
      // y esperar a que el usuario presione Aceptar.
      final resultado = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PedidoEnviadoScreen(
            numeroPedido:
            'Pedido #$numeroFormateado',
          ),
        ),
      );

      if (!mounted) {
        return;
      }

      // Si presionó Aceptar,
      // regresamos a TomaPedidoScreen enviando true.
      if (resultado == true) {
        Navigator.pop(
          context,
          true,
        );
      } else {
        // Si regresó con la flecha de Android,
        // permitimos continuar en esta pantalla.
        setState(() {
          enviando = false;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        enviando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo enviar el pedido: $e',
          ),
        ),
      );
    }
  }
}