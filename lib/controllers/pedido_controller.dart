import '../models/producto.dart';

class PedidoController {
  final List<Producto> productos = [
    Producto(
      nombre: 'Pastor',
      categoria: 'Tacos',
      precio: 30,
      emoji: '🌮',
    ),
    Producto(
      nombre: 'Asada',
      categoria: 'Tacos',
      precio: 35,
      emoji: '🌮',
    ),
    Producto(
      nombre: 'Bistec',
      categoria: 'Tacos',
      precio: 32,
      emoji: '🌮',
    ),

    Producto(
      nombre: 'Hamburguesa Clásica',
      categoria: 'Hamburguesas',
      precio: 85,
      emoji: '🍔',
    ),
    Producto(
      nombre: 'Hamburguesa Doble',
      categoria: 'Hamburguesas',
      precio: 110,
      emoji: '🍔',
    ),

    Producto(
      nombre: 'Coca-Cola',
      categoria: 'Bebidas',
      precio: 25,
      emoji: '🥤',
    ),
    Producto(
      nombre: 'Agua',
      categoria: 'Bebidas',
      precio: 20,
      emoji: '🧴',
    ),

    Producto(
      nombre: 'Papas',
      categoria: 'Extras',
      precio: 45,
      emoji: '🍟',
    ),
    Producto(
      nombre: 'Guacamole',
      categoria: 'Extras',
      precio: 35,
      emoji: '🥑',
    ),
    Producto(
      nombre: 'Salsa',
      categoria: 'Extras',
      precio: 10,
      emoji: '🌶️',
    ),
  ];

  List<Producto> obtenerPorCategoria(String categoria) {
    return productos
        .where(
          (producto) => producto.categoria == categoria,
    )
        .toList();
  }

  void aumentarCantidad(Producto producto) {
    producto.cantidad++;
  }

  void disminuirCantidad(Producto producto) {
    if (producto.cantidad > 0) {
      producto.cantidad--;
    }
  }

  double calcularTotal() {
    double total = 0;

    for (Producto producto in productos) {
      total += producto.subtotal;
    }

    return total;
  }

  List<Producto> obtenerProductosSeleccionados() {
    return productos
        .where(
          (producto) => producto.cantidad > 0,
    )
        .toList();
  }

  void reiniciarPedido() {
    for (Producto producto in productos) {
      producto.cantidad = 0;
    }
  }
}