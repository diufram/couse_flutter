import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductRepository repo;
  ProductsProvider(this.repo);

  List<Product> items = [];
  bool loading = false;
  String? error;

  /// Obtener todos los productos
  Future<void> fetchAll({String? q}) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      items = await repo.list(q: q);
    } catch (e, st) {
      debugPrint('fetchAll error: $e\n$st');
      error = 'Error al cargar productos';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Crear producto
/*   Future<Product?> create(Product product) async {
    try {
      final created = await repo.create(product);
      items = [created, ...items];
      notifyListeners();
      return created;
    } catch (e, st) {
      debugPrint('create error: $e\n$st');
      error = 'Error al crear producto';
      notifyListeners();
      return null;
    }
  } */

  /// Actualizar producto
/*   Future<Product?> update(int id, Product product) async {
    try {
      final updated = await repo.update(id, product);
      items = items.map((p) => p.id == id ? updated : p).toList();
      notifyListeners();
      return updated;
    } catch (e, st) {
      debugPrint('update error: $e\n$st');
      error = 'Error al actualizar producto';
      notifyListeners();
      return null;
    }
  }
 */
  /// Eliminar producto
  Future<bool> delete(int id) async {
    try {
      await repo.delete(id);
      items.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e, st) {
      debugPrint('delete error: $e\n$st');
      error = 'Error al eliminar producto';
      notifyListeners();
      return false;
    }
  }
}
