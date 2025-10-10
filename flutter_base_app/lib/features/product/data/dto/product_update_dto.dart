class ProductUpdateDto {
  final String? name;
  final String? description;
  final String? imageKey;
  final String? mime;
  final int? size;
  final String? price; // String
  final int? stock;
  final bool? isActive;
  final int? ownerId;

  ProductUpdateDto({
    this.name,
    this.description,
    this.imageKey,
    this.mime,
    this.size,
    this.price,
    this.stock,
    this.isActive,
    this.ownerId,
  });

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (description != null) 'description': description,
    if (imageKey != null) 'imageKey': imageKey,
    if (mime != null) 'mime': mime,
    if (size != null) 'size': size,
    if (price != null) 'price': price,
    if (stock != null) 'stock': stock,
    if (isActive != null) 'isActive': isActive,
    if (ownerId != null) 'ownerId': ownerId,
  };
}
