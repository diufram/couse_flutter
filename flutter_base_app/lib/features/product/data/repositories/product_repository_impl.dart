import 'package:flutter_base_app/features/product/data/datasources/product_remote_data_source.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;

  ProductRepositoryImpl(this.remote);

  @override
  Future<List<Product>> list({String? q}) async {
    return remote.list(q: q);
  }

  @override
  Future<Product> getById(int id) => remote.getById(id);




  @override
  Future<void> delete(int id) => remote.delete(id);
  
  @override
  Future<void> create(Product draft) {
    // TODO: implement create
    throw UnimplementedError();
  }
  
  @override
  Future<void> update(int id, Product draft) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
