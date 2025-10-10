import 'package:dio/dio.dart';
import 'package:flutter_base_app/features/product/data/dto/product_create_dto.dart';
import '../../domain/entities/product.dart';
import '../dto/product_update_dto.dart';

class ProductRemoteDataSource {
  final Dio dio;
  ProductRemoteDataSource(this.dio);

  Future<List<Product>> list({int page = 1, int limit = 20, String? q}) async {
    final res = await dio.get(
      '/products',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (q != null && q.isNotEmpty) 'q': q,
      },
    );
    final data = res.data;
    final items = (data is Map && data['items'] is List)
        ? data['items'] as List
        : (data as List);
    return items
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Product> getById(int id) async {
    final res = await dio.get('/products/$id');
    return Product.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<Product> create(ProductCreateDto dto) async {
    final res = await dio.post('/products', data: dto.toJson());
    return Product.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<Product> update(int id, ProductUpdateDto dto) async {
    final res = await dio.patch('/products/$id', data: dto.toJson());
    return Product.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<void> delete(int id) async {
    await dio.delete('/products/$id');
  }
}
