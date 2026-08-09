class Producto {
  final String nombre;
  final String categoria;
  final double precio;
  final String emoji;

  int cantidad;

  Producto({
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.emoji,
    this.cantidad = 0,
  });

  double get subtotal {
    return precio * cantidad;
  }
}