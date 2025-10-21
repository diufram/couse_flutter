// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String,
  price: json['price'] as String,
  stock: (json['stock'] as num).toInt(),
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  categoryId: (json['categoryId'] as num).toInt(),
  category: Category.fromJson(json['category'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'price': instance.price,
  'stock': instance.stock,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'categoryId': instance.categoryId,
  'category': instance.category,
};
