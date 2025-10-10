class ProductCreateDto {
  final String name;
  final String? description;
  final String? imageKey;
  final String? mime;
  final int? size;

  /// Mantén price como String (ej: "149.90")
  final String price;
  final int stock;
  final bool isActive;
  final int? ownerId;

  ProductCreateDto({
    required this.name,
    this.description,
    this.imageKey,
    this.mime,
    this.size,
    required this.price,
    this.stock = 0,
    this.isActive = true,
    this.ownerId,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'imageKey': imageKey,
    'mime': mime,
    'size': size,
    'price': price,
    'stock': stock,
    'isActive': isActive,
    'ownerId': ownerId,
  };
}
