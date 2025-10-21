import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../provider/product_provider.dart';

/// Vista reutilizable para listar productos.
/// - Hace fetch inicial
/// - Soporta búsqueda con debounce
/// - Pull-to-refresh
/// - Grid responsive
/// - Callback onTap para cada item
class ProductListView extends StatefulWidget {
  const ProductListView({
    super.key,
    this.onTap,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.padding,
    this.showSearch = true,
    this.initialQuery,
  });

  final ValueChanged<Product>? onTap;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsets? padding;
  final bool showSearch;
  final String? initialQuery;

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchCtrl.text = widget.initialQuery!;
    }

    // Fetch inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().fetchAll(q: _q);
    });

    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  String? get _q {
    final t = _searchCtrl.text.trim();
    return t.isEmpty ? null : t;
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      context.read<ProductsProvider>().fetchAll(q: _q);
    });
  }

  int _columnsForWidth(double w) {
    if (w < 600) return 2;
    if (w < 1024) return 3;
    return 4;
  }

  double _aspectRatioForWidth(double w) {
    return w < 600 ? 1.0 : 4 / 3;
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>();
    final width = MediaQuery.of(context).size.width;
    final cols = _columnsForWidth(width);
    final ratio = _aspectRatioForWidth(width);

    return Column(
      children: [
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null,
              ),
            ),
          ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: () => products.fetchAll(q: _q),
            child: Builder(
              builder: (_) {
                if (products.loading && products.items.isEmpty) {
                  return const _CenteredProgress();
                }

                if (products.error != null && products.items.isEmpty) {
                  return _CenteredMessage(
                    icon: Icons.error_outline,
                    message: products.error!,
                    onRetry: () => products.fetchAll(q: _q),
                  );
                }

                if (products.items.isEmpty) {
                  return _CenteredMessage(
                    icon: Icons.inventory_2_outlined,
                    message: 'No hay productos',
                    secondary: _q != null
                        ? 'Prueba limpiando la búsqueda'
                        : null,
                  );
                }

                return GridView.builder(
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  itemCount: products.items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: widget.crossAxisSpacing,
                    mainAxisSpacing: widget.mainAxisSpacing,
                    childAspectRatio: ratio,
                  ),
                  itemBuilder: (_, i) {
                    final p = products.items[i];
                    return _ProductCard(product: p, onTap: widget.onTap);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// ---------- CARD DE PRODUCTO ----------
class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, this.onTap});

  final Product product;
  final ValueChanged<Product>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = product.imageUrl;
    final price = product.price;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl == null || imageUrl.isEmpty
                      ? Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: const Center(
                            child: Icon(Icons.image_not_supported_outlined),
                          ),
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: theme.colorScheme.surfaceVariant,
                            child: const Center(
                              child: Icon(Icons.broken_image_outlined),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$$price',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: (product.stock > 0)
                        ? Colors.green
                        : theme.colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    product.stock > 0 ? 'Stock: ${product.stock}' : 'Sin stock',
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------- ESTADOS REUTILIZABLES ----------
class _CenteredProgress extends StatelessWidget {
  const _CenteredProgress();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.message,
    this.secondary,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final String? secondary;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {},
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 42),
              const SizedBox(height: 12),
              Text(message, style: t.titleMedium, textAlign: TextAlign.center),
              if (secondary != null) ...[
                const SizedBox(height: 4),
                Text(
                  secondary!,
                  style: t.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
