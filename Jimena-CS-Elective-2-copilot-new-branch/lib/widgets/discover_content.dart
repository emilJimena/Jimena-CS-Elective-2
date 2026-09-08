import 'package:flutter/material.dart';

import '../models/product.dart';
import '../pages/product_detail_page.dart';

// Static Home content: supplier cards do not manage their own changing state.
class DiscoverContent extends StatelessWidget {
  const DiscoverContent({super.key, required this.onAddToCart});

  final ValueChanged<Product> onAddToCart;

  static const suppliers = [
    (
      'Trendsi',
      '4.7',
      [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300',
        'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=300',
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300',
      ],
    ),
    (
      'Cozy Earth',
      '4.6',
      [
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=300',
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=300',
        'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=300',
      ],
    ),
    (
      'Go Ruck',
      '4.4',
      [
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300',
        'https://images.unsplash.com/photo-1491637639811-60e049f4b8c1?w=300',
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=300',
      ],
    ),
    (
      'Come What Mae',
      '4.7',
      [
        'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=300',
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300',
        'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=300',
      ],
    ),
    (
      'VICI',
      '4.5',
      [
        'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=300',
        'https://images.unsplash.com/photo-1506629905607-d9c297d3e4aa?w=300',
        'https://images.unsplash.com/photo-1566206091558-7f218b696731?w=300',
      ],
    ),
    (
      'Universal Standard',
      '4.2',
      [
        'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=300',
        'https://images.unsplash.com/photo-1548883354-7622d03aca27?w=300',
        'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=300',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 28, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover new products to sell',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 18),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Icon(Icons.search, size: 17),
                      hintText: 'Search for products and brands',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SectionTitle(
                title: 'Instant import',
                subtitle:
                    'Add products to your store instantly without waiting for approval',
              ),
              const SizedBox(height: 8),
              SupplierGrid(suppliers: suppliers.take(3).toList()),
              const SizedBox(height: 18),
              const SectionTitle(
                title: 'Recommended suppliers',
                subtitle:
                    'Boost profits with preferred suppliers your customers will love',
              ),
              const SizedBox(height: 8),
              SupplierGrid(suppliers: suppliers.skip(3).toList()),
              const SizedBox(height: 22),
              PickedForYou(onAddToCart: onAddToCart),
              const SizedBox(height: 26),
              MoreProducts(onAddToCart: onAddToCart),
            ],
          ),
        ),
      ),
    ),
  );
}

class PickedForYou extends StatelessWidget {
  const PickedForYou({super.key, required this.onAddToCart});

  final ValueChanged<Product> onAddToCart;

  static const products = [
    (
      'French Connection US',
      'Vhari Collar Long Sleeve Sweater',
      '₱78.00',
      '4.8',
      'https://images.unsplash.com/photo-1543076447-215ad9ba6923?w=400',
    ),
    (
      'Trendsi',
      'Striped Boat Neck Drop Shoulder Sweater',
      '₱42.00',
      '4.7',
      'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
    ),
    (
      'Varley US',
      'Striped Boat Neck Drop Shoulder Sweater',
      '₱78.00',
      '5.0',
      'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400',
    ),
    (
      'Come What Mae',
      'POL V-Neck Long Sleeve Flower Fringe Sweater',
      '₱54.00',
      '4.9',
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400',
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        title: 'Picked for you',
        subtitle:
            'Increase AOV by adding women\'s knitwear to your best sellers',
      ),
      const SizedBox(height: 8),
      LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 600 ? 2 : 3;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: columns == 2 ? .72 : 1.1,
            ),
            itemBuilder: (context, index) => PickedProductCard(
              product: products[index],
              onAddToCart: onAddToCart,
            ),
          );
        },
      ),
    ],
  );
}

class PickedProductCard extends StatelessWidget {
  const PickedProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.width,
  });
  final Product product;
  final ValueChanged<Product> onAddToCart;
  final double? width;

  Future<void> _openAddDialog(BuildContext context) async {
    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to cart'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 130,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  product.$5,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.checkroom,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.$2,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text('${product.$1}  •  ${product.$3}'),
            const SizedBox(height: 12),
            const Text('Add this product to your cart?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add to cart'),
          ),
        ],
      ),
    );
    if (shouldAdd == true && context.mounted) onAddToCart(product);
  }

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductDetailPage(product: product, onAddToCart: onAddToCart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90,
              width: double.infinity,
              child: Image.network(
                product.$5,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.checkroom,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.$2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text('★ ${product.$4}', style: const TextStyle(fontSize: 10)),
                  const SizedBox(height: 3),
                  Text(
                    product.$3,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 25,
                    child: FilledButton(
                      onPressed: () => _openAddDialog(context),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      child: const Text('Add to cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class MoreProducts extends StatelessWidget {
  const MoreProducts({super.key, required this.onAddToCart});

  final ValueChanged<Product> onAddToCart;

  static const products = [
    (
      'Mango',
      'Relaxed Cotton Cardigan',
      '₱49.00',
      '4.6',
      'https://images.unsplash.com/photo-1591369822096-ffd140ec948f?w=400',
    ),
    (
      'VICI',
      'Soft Knit Button Sweater',
      '₱64.00',
      '4.8',
      'https://images.unsplash.com/photo-1578587018452-892bacefd3f2?w=400',
    ),
    (
      'Trendsi',
      'Cable Knit Oversized Pullover',
      '₱56.00',
      '4.5',
      'https://images.unsplash.com/photo-1608234807905-4466023792f5?w=400',
    ),
    (
      'French Connection US',
      'Textured Wool Blend Jumper',
      '₱82.00',
      '4.9',
      'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=400',
    ),
    (
      'Come What Mae',
      'Floral Detail Knit Top',
      '₱45.00',
      '4.7',
      'https://images.unsplash.com/photo-1564257577054-6e7f7b0a0d4e?w=400',
    ),
    (
      'Universal Standard',
      'Everyday Ribbed Pullover',
      '₱72.00',
      '4.4',
      'https://images.unsplash.com/photo-1598808503746-f34c53b9323e?w=400',
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        title: 'More products',
        subtitle: 'Keep browsing products ready to import to your store',
      ),
      const SizedBox(height: 8),
      LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 600 ? 2 : 3;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: columns == 2 ? .72 : 1.1,
            ),
            itemBuilder: (context, index) => PickedProductCard(
              product: products[index],
              onAddToCart: onAddToCart,
            ),
          );
        },
      ),
    ],
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 3),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      TextButton(
        onPressed: () {},
        child: const Text('View more', style: TextStyle(fontSize: 12)),
      ),
    ],
  );
}

class SupplierGrid extends StatelessWidget {
  const SupplierGrid({super.key, required this.suppliers});
  final List<(String, String, List<String>)> suppliers;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth > 700 ? 3 : 1;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: suppliers.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 10,
          mainAxisSpacing: 8,
          childAspectRatio: 2.15,
        ),
        itemBuilder: (context, index) => SupplierCard(
          name: suppliers[index].$1,
          rating: suppliers[index].$2,
          images: suppliers[index].$3,
        ),
      );
    },
  );
}

class SupplierCard extends StatelessWidget {
  const SupplierCard({
    super.key,
    required this.name,
    required this.rating,
    required this.images,
  });
  final String name;
  final String rating;
  final List<String> images;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.storefront, size: 14),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Icon(Icons.star, color: Colors.amber, size: 13),
              const SizedBox(width: 2),
              Text(rating, style: const TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.bolt,
                color: Theme.of(context).colorScheme.primary,
                size: 12,
              ),
              const Text(
                ' Instant import  •  20-30% margin',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: Row(children: _thumbnailWidgets(context))),
        ],
      ),
    ),
  );

  List<Widget> _thumbnailWidgets(BuildContext context) => images
      .map(
        (url) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      )
      .toList();
}
