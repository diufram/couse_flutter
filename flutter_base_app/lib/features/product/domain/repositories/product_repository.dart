import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> list({String? q});
  Future<Product> getById(int id);
  Future<void> create(Product draft);
  Future<void> update(int id, Product draft);
  Future<void> delete(int id);
}
