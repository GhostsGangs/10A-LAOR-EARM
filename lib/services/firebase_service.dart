import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/producto.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> guardarPedido({
    required String mesa,
    required String tipoPedido,
    required List<Producto> productos,
    required double total,
  }) async {
    final contadorRef =
    _firestore.collection('contadores').doc('pedidos');

    final pedidosRef =
    _firestore.collection('pedidos');

    return _firestore.runTransaction<int>((transaction) async {
      final contadorSnapshot =
      await transaction.get(contadorRef);

      int ultimoNumero = 0;

      if (contadorSnapshot.exists) {
        final data = contadorSnapshot.data();

        if (data != null && data['ultimoNumero'] != null) {
          ultimoNumero = data['ultimoNumero'] as int;
        }
      }

      final int nuevoNumero = ultimoNumero + 1;

      final String idPedido =
      nuevoNumero.toString().padLeft(4, '0');

      final pedidoRef = pedidosRef.doc(idPedido);

      final List<Map<String, dynamic>> productosData =
      productos.map((producto) {
        return {
          'nombre': producto.nombre,
          'categoria': producto.categoria,
          'precio': producto.precio,
          'cantidad': producto.cantidad,
          'subtotal': producto.subtotal,
        };
      }).toList();

      transaction.set(
        contadorRef,
        {
          'ultimoNumero': nuevoNumero,
        },
      );

      transaction.set(
        pedidoRef,
        {
          'numeroPedido': nuevoNumero,
          'codigoPedido': 'Pedido #$idPedido',
          'mesa': mesa,
          'tipoPedido': tipoPedido,
          'productos': productosData,
          'total': total,
          'estado': 'Recibido',
          'fecha': FieldValue.serverTimestamp(),
        },
      );

      return nuevoNumero;
    });
  }
}