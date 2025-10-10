class Product {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl; // p.ej. "/uploads/products/a.webp"
  final String? imageKey; // nombre de archivo en /uploads/products
  final String? mime; // p.ej. "image/webp"
  final int? size; // bytes
  /// Decimal(10,2) → lo guardamos como String para no perder precisión
  final String price; // ejemplo: "199.99"
  final int stock;
  final bool isActive;
  final int? ownerId;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.imageKey,
    this.mime,
    this.size,
    required this.price,
    required this.stock,
    required this.isActive,
    this.ownerId,
    required this.createdAt,
  });

  /// Útil si querés mostrar o calcular rápido (ojo con precisión).
  double get priceDouble => double.tryParse(price) ?? 0.0;

  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    String? imageKey,
    String? mime,
    int? size,
    String? price,
    int? stock,
    bool? isActive,
    int? ownerId,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      imageKey: imageKey ?? this.imageKey,
      mime: mime ?? this.mime,
      size: size ?? this.size,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Espera JSON con `price` como String (recomendado).
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _asInt(json['id']),
      name: (json['name'] ?? '') as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      imageKey: json['imageKey'] as String?,
      mime: json['mime'] as String?,
      size: _asIntOrNull(json['size']),
      price: _asPriceString(json['price']),
      stock: _asInt(json['stock']),
      isActive: (json['isActive'] ?? true) as bool,
      ownerId: _asIntOrNull(json['ownerId']),
      createdAt: _asDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'imageKey': imageKey,
    'mime': mime,
    'size': size,
    'price': price, // enviamos como String
    'stock': stock,
    'isActive': isActive,
    'ownerId': ownerId,
    'createdAt': createdAt.toIso8601String(),
  };

  // -------- helpers de parseo seguros --------
  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static int? _asIntOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }

  static String _asPriceString(dynamic v) {
    if (v == null) return '0.00';
    if (v is String) return v;
    if (v is num) return v.toStringAsFixed(2);
    return v.toString();
  }

  static DateTime _asDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String)
      return DateTime.tryParse(v) ?? DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
