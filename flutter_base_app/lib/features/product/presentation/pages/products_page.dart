import 'package:flutter/material.dart';
import 'package:flutter_base_app/features/product/presentation/widgets/product_list_view.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Asegúrate de tener registrado ProductsProvider en tu DI
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: const ProductListView(
        // Ejemplo: abre detalle al tocar
        // onTap: (Product p) => context.go('/products/${p.id}'),
      ),
    );
  }
}
