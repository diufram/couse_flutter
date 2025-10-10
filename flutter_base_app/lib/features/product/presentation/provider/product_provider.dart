import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/dto/product_create_dto.dart';
import '../../data/dto/product_update_dto.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductRepository repo;
  ProductsProvider(this.repo);

  List<Product> items = [];
  bool loading = false;
  String? error;

  Future<void> fetchAll({int page = 1, int limit = 20, String? q}) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      items = await repo.list(page: page, limit: limit, q: q);
    } catch (e, st) {
      debugPrint('fetchAll error: $e\n$st');
      error = 'Error al cargar productos';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Product?> create(ProductCreateDto dto) async {
    try {
      final product = await repo.create(dto);
      items = [product, ...items];
      notifyListeners();
      return product;
    } catch (e) {
      error = 'Error al crear producto';
      notifyListeners();
      return null;
    }
  }

  Future<Product?> update(int id, ProductUpdateDto dto) async {
    try {
      final updated = await repo.update(id, dto);
      items = items.map((p) => p.id == id ? updated : p).toList();
      notifyListeners();
      return updated;
    } catch (e) {
      error = 'Error al actualizar producto';
      notifyListeners();
      return null;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await repo.delete(id);
      items.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      error = 'Error al eliminar producto';
      notifyListeners();
      return false;
    }
  }
}
