import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
    const factory Product({
        required int id,
        required String name,
        required String description,
        required String imageUrl,
        required String price,
        required int stock,
        required bool isActive,
        required DateTime createdAt,
        required int categoryId,
        required Category category,
    }) = _Product;

    factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
