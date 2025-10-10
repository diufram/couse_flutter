import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../dto/product_create_dto.dart';
import '../dto/product_update_dto.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;
  ProductRepositoryImpl(this.remote);

  @override
  Future<Product> create(ProductCreateDto dto) => remote.create(dto);

  @override
  Future<void> delete(int id) => remote.delete(id);

  @override
  Future<Product> getById(int id) => remote.getById(id);

  @override
  Future<List<Product>> list({int page = 1, int limit = 20, String? q}) =>
      remote.list(page: page, limit: limit, q: q);

  @override
  Future<Product> update(int id, ProductUpdateDto dto) =>
      remote.update(id, dto);
}
