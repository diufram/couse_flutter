import '../entities/product.dart';
import '../../data/dto/product_create_dto.dart';
import '../../data/dto/product_update_dto.dart';

abstract class ProductRepository {
  Future<List<Product>> list({int page, int limit, String? q});
  Future<Product> getById(int id);
  Future<Product> create(ProductCreateDto dto);
  Future<Product> update(int id, ProductUpdateDto dto);
  Future<void> delete(int id);
}
