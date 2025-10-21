// features/product/data/datasources/product_remote_ds.dart

import 'package:dio/dio.dart';
import '../../domain/entities/product.dart';

class ProductRemoteDataSource {
  final Dio dio;
  static const _basePath = '/products';

  ProductRemoteDataSource(this.dio);

  /// Obtener todos los productos
  Future<List<Product>> list({String? q}) async {
    final res = await dio.get(
      _basePath,
      queryParameters: {
        if (q != null && q.isNotEmpty) 'q': q,
      },
    );

    final data = res.data;
    final items = data is List ? data : (data['items'] as List);
    return items
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Obtener un producto por ID
  Future<Product> getById(int id) async {
    final res = await dio.get('$_basePath/$id');
    return Product.fromJson(Map<String, dynamic>.from(res.data));
  }

  /// Crear un nuevo producto
  Future<void> create(String dto) async {
    /*     final res = await dio.post(_basePath, data: dto.toJson());
    return ProductDto.fromJson(Map<String, dynamic>.from(res.data)).toEntity(); */
  }

  /// Actualizar un producto existente
  Future<void> update(int id, String dto) async {
    /* final res = await dio.patch('$_basePath/$id', data: dto.toJson());
    return ProductDto.fromJson(Map<String, dynamic>.from(res.data)).toEntity(); */
  }

  /// Eliminar un producto
  Future<void> delete(int id) async {
    await dio.delete('$_basePath/$id');
  }
}
