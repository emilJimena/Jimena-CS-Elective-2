import 'package:cs_elective_2/models/product.dart';
import 'package:cs_elective_2/pages/AddProduct.dart';
import 'package:cs_elective_2/pages/CartScreen.dart';
import 'package:cs_elective_2/providers/auth_providers.dart';
import 'package:cs_elective_2/providers/cart_provider.dart';
import 'package:cs_elective_2/providers/category_provider.dart';
import 'package:cs_elective_2/providers/product_filter_provider.dart';
import 'package:cs_elective_2/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }

  Future<void> _confirmDelete(Product p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${p.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await ref.read(productProvider.notifier).deleteProduct(p.id);
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  void _editProduct(Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductPage(product: p)),
    );
  }

  void _buyProduct(Product product) {
    ref.read(cartProvider.notifier).addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View cart',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider).value ?? false;
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag),
            tooltip: 'Cart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      // only admins can add products
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductPage()),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (products) {
                final filter = ref.watch(productFilterProvider);

                if (products.isEmpty) {
                  return const Center(child: Text('No products yet'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(productProvider);
                    await ref.read(productProvider.future);
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Page ${filter.page}'),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: filter.page > 1
                                      ? () => ref
                                          .read(productFilterProvider.notifier)
                                          .setPage(filter.page - 1)
                                      : null,
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Prev'),
                                ),
                                TextButton.icon(
                                  onPressed: products.length >= filter.pageSize
                                      ? () => ref
                                          .read(productFilterProvider.notifier)
                                          .setPage(filter.page + 1)
                                      : null,
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('Next'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: products.length,
                          itemBuilder: (_, i) {
                            final p = products[i];
                            return InkWell(
                              onTap: () => _buyProduct(p),
                              borderRadius: BorderRadius.circular(12),
                              child: Card(
                                elevation: i % 2 == 0 ? 4 : 2,
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          p.imageUrl != null && p.imageUrl!.isNotEmpty
                                              ? Image.network(
                                                  p.imageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                          size: 40,
                                                        ),
                                                      ),
                                                  loadingBuilder:
                                                      (context, child, progress) {
                                                    if (progress == null) {
                                                      return child;
                                                    }
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  },
                                                )
                                              : const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 40,
                                                  ),
                                                ),

                                          if (isAdmin)
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: Colors.white70,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      iconSize: 20,
                                                      icon: const Icon(Icons.edit),
                                                      onPressed: () => _editProduct(p),
                                                    ),
                                                  ),
                                                  CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: Colors.white70,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      iconSize: 20,
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.redAccent,
                                                      ),
                                                      onPressed: () =>
                                                          _confirmDelete(p),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            p.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 4),
                                          Text('₱${p.price.toStringAsFixed(2)}'),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: () => _buyProduct(p),
                                              icon: const Icon(Icons.shopping_cart),
                                              label: const Text('Buy'),
                                            ),
                                          ),
                                          if (p.stock < 5)
                                            const Text(
                                              'Low stock',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final filter = ref.watch(productFilterProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        children: [
          categoriesAsync.maybeWhen(
            data: (categories) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DropdownButtonFormField<int?>(
                value: filter.categoryId,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('All categories'),
                  ),
                  ...categories.map(
                    (category) => DropdownMenuItem<int?>(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  ref.read(productFilterProvider.notifier).setCategoryId(value);
                },
              ),
            ),
            orElse: () => const SizedBox(height: 56),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Price range'),
              Text(
                '₱${(filter.minPrice ?? 0).round()} - ₱${(filter.maxPrice ?? 5000).round()}',
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(
              filter.minPrice ?? 0,
              filter.maxPrice ?? 5000,
            ),
            min: 0,
            max: 5000,
            divisions: 50,
            labels: RangeLabels(
              '₱${(filter.minPrice ?? 0).round()}',
              '₱${(filter.maxPrice ?? 5000).round()}',
            ),
            onChanged: (values) {
              final min = values.start == 0 ? null : values.start;
              final max = values.end == 5000 ? null : values.end;
              ref.read(productFilterProvider.notifier).setPriceRange(
                minPrice: min,
                maxPrice: max,
              );
            },
          ),
        ],
      ),
    );
  }
}
