import 'package:flutter/material.dart';

import '../controllers/pedido_controller.dart';
import '../models/producto.dart';
import '../services/clima_service.dart';
import 'confirmar_pedido_screen.dart';

class TomaPedidoScreen extends StatefulWidget {
  const TomaPedidoScreen({super.key});

  @override
  State<TomaPedidoScreen> createState() => _TomaPedidoScreenState();
}

class _TomaPedidoScreenState extends State<TomaPedidoScreen> {
  final PedidoController controller = PedidoController();
  final ClimaService climaService = ClimaService();

  String categoriaSeleccionada = 'Tacos';
  String mesaSeleccionada = 'Mesa 1';
  String tipoPedido = 'Comer aquí';

  String temperatura = '--°C';
  String emojiClima = '🌤️';
  String fechaActual = '--/--/----';
  String horaActual = '--:-- --';

  bool cargandoClima = true;

  final List<String> categorias = [
    'Tacos',
    'Hamburguesas',
    'Bebidas',
    'Extras',
  ];

  final List<String> mesas = [
    'Mesa 1',
    'Mesa 2',
    'Mesa 3',
    'Mesa 4',
    'Mesa 5',
    'Mesa 6',
    'Mesa 7',
    'Mesa 8',
  ];

  @override
  void initState() {
    super.initState();
    cargarDatosClima();
  }

  Future<void> cargarDatosClima() async {
    try {
      final datos =
      await climaService.obtenerDatosMonterrey();

      final int temperaturaApi =
      datos['temperatura'];

      final int codigoClima =
      datos['codigoClima'];

      final DateTime fechaHora =
      datos['fechaHora'];

      if (!mounted) {
        return;
      }

      setState(() {
        temperatura = '$temperaturaApi°C';

        emojiClima =
            climaService.obtenerEmojiClima(
              codigoClima,
            );

        fechaActual =
            climaService.formatearFecha(
              fechaHora,
            );

        horaActual =
            climaService.formatearHora(
              fechaHora,
            );

        cargandoClima = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        cargandoClima = false;
      });

      debugPrint(
        'Error al cargar clima: $e',
      );
    }
  }

  String obtenerEmojiCategoria(
      String categoria,
      ) {
    switch (categoria) {
      case 'Tacos':
        return '🌮';

      case 'Hamburguesas':
        return '🍔';

      case 'Bebidas':
        return '🥤';

      case 'Extras':
        return '🍟';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Producto> productos =
    controller.obtenerPorCategoria(
      categoriaSeleccionada,
    );

    return Scaffold(
      backgroundColor:
      const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🌮',
              style: TextStyle(
                fontSize: 27,
              ),
            ),

            SizedBox(width: 8),

            Text(
              'TacoExpress',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    // CLIMA, FECHA Y HORA
                    Card(
                      child: Padding(
                        padding:
                        const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,
                          children: [
                            // Clima
                            Column(
                              children: [
                                if (cargandoClima)
                                  const SizedBox(
                                    width: 25,
                                    height: 25,
                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  Text(
                                    emojiClima,
                                    style:
                                    const TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),

                                const SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  temperatura,
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const Text(
                                  'Monterrey',
                                ),
                              ],
                            ),

                            Container(
                              width: 1,
                              height: 60,
                              color:
                              Colors.grey.shade300,
                            ),

                            // Fecha y hora
                            Column(
                              children: [
                                Text(
                                  '📅 $fechaActual',
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(
                                  '🕒 $horaActual',
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Seleccionar mesa
                    DropdownButtonFormField<
                        String>(
                      value: mesaSeleccionada,
                      decoration:
                      const InputDecoration(
                        labelText:
                        'Seleccionar mesa',
                        border:
                        OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.table_restaurant,
                        ),
                      ),
                      items: mesas.map((mesa) {
                        return DropdownMenuItem<
                            String>(
                          value: mesa,
                          child: Text(mesa),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          setState(() {
                            mesaSeleccionada =
                                valor;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Categorías',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Categorías
                    SizedBox(
                      height: 55,
                      child: ListView.separated(
                        scrollDirection:
                        Axis.horizontal,
                        itemCount:
                        categorias.length,
                        separatorBuilder:
                            (context, index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                        itemBuilder:
                            (context, index) {
                          final String categoria =
                          categorias[index];

                          final bool seleccionado =
                              categoriaSeleccionada ==
                                  categoria;

                          return ChoiceChip(
                            selected:
                            seleccionado,
                            label: Text(
                              '${obtenerEmojiCategoria(categoria)} $categoria',
                            ),
                            onSelected: (valor) {
                              setState(() {
                                categoriaSeleccionada =
                                    categoria;
                              });
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      categoriaSeleccionada,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const Divider(),

                    // Productos
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount:
                      productos.length,
                      itemBuilder:
                          (context, index) {
                        final Producto producto =
                        productos[index];

                        return Card(
                          margin:
                          const EdgeInsets
                              .symmetric(
                            vertical: 7,
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets
                                .all(14),
                            child: Row(
                              children: [
                                Text(
                                  producto.emoji,
                                  style:
                                  const TextStyle(
                                    fontSize: 32,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        producto
                                            .nombre,
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          17,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 3,
                                      ),

                                      Text(
                                        '\$${producto.precio.toStringAsFixed(2)}',
                                      ),
                                    ],
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      controller
                                          .disminuirCantidad(
                                        producto,
                                      );
                                    });
                                  },
                                  icon: const Icon(
                                    Icons
                                        .remove_circle,
                                  ),
                                ),

                                Text(
                                  producto.cantidad
                                      .toString(),
                                  style:
                                  const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      controller
                                          .aumentarCantidad(
                                        producto,
                                      );
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add_circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    const Divider(),

                    const SizedBox(height: 10),

                    const Text(
                      'Tipo de pedido',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    RadioListTile<String>(
                      title: const Text(
                        '🍽 Comer aquí',
                      ),
                      value: 'Comer aquí',
                      groupValue: tipoPedido,
                      onChanged: (valor) {
                        if (valor != null) {
                          setState(() {
                            tipoPedido = valor;
                          });
                        }
                      },
                    ),

                    RadioListTile<String>(
                      title: const Text(
                        '🥡 Para llevar',
                      ),
                      value: 'Para llevar',
                      groupValue: tipoPedido,
                      onChanged: (valor) {
                        if (valor != null) {
                          setState(() {
                            tipoPedido = valor;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // PARTE INFERIOR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      Text(
                        '\$${controller.calcularTotal().toStringAsFixed(2)}',
                        style:
                        const TextStyle(
                          fontSize: 25,
                          fontWeight:
                          FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child:
                    ElevatedButton.icon(
                      onPressed:
                      confirmarPedido,
                      icon: const Icon(
                        Icons.check_circle,
                      ),
                      label: const Text(
                        'Confirmar pedido',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirmarPedido() async {
    final List<Producto> seleccionados =
    controller
        .obtenerProductosSeleccionados();

    if (seleccionados.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Selecciona al menos un producto.',
          ),
        ),
      );

      return;
    }

    final resultado =
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConfirmarPedidoScreen(
              mesa: mesaSeleccionada,
              tipoPedido: tipoPedido,
              productos: seleccionados,
              total:
              controller.calcularTotal(),
            ),
      ),
    );

    if (!mounted) {
      return;
    }

    if (resultado == true) {
      setState(() {
        controller.reiniciarPedido();

        categoriaSeleccionada = 'Tacos';
        mesaSeleccionada = 'Mesa 1';
        tipoPedido = 'Comer aquí';
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Listo para tomar un nuevo pedido.',
          ),
        ),
      );
    }
  }
}