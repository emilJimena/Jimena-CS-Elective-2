import 'package:flutter/material.dart';

import '../models/product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;

  double get unitPrice =>
      double.parse(product.$3.replaceAll(RegExp(r'[^0-9.]'), ''));

  double get subtotal => unitPrice * quantity;
}

class CartSheet extends StatefulWidget {
  const CartSheet({
    super.key,
    required this.products,
    required this.onCheckout,
    required this.onQuantityChanged,
  });

  final List<CartItem> products;
  final VoidCallback onCheckout;
  final ValueChanged<CartItem> onQuantityChanged;

  @override
  State<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<CartSheet> {
  double get total =>
      widget.products.fold(0, (sum, item) => sum + item.subtotal);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Cart', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            if (widget.products.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(child: Text('Your cart is empty.')),
              )
            else ...[
              ...widget.products.asMap().entries.map(
                (entry) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text('${entry.value.quantity}')),
                  title: Text(entry.value.product.$2),
                  subtitle: Text(
                    '${entry.value.product.$1}  •  ${entry.value.product.$3}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Decrease quantity',
                        onPressed: () {
                          entry.value.quantity--;
                          widget.onQuantityChanged(entry.value);
                          setState(() {});
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('${entry.value.quantity}'),
                      IconButton(
                        tooltip: 'Increase quantity',
                        onPressed: () {
                          entry.value.quantity++;
                          widget.onQuantityChanged(entry.value);
                          setState(() {});
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₱${entry.value.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '₱${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onCheckout();
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Checkout'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class OrdersContent extends StatelessWidget {
  const OrdersContent({super.key, required this.products});

  final List<CartItem> products;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Orders', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Products completed through checkout.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              if (products.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No orders yet. Add a product to your cart to get started.',
                      ),
                    ),
                  ),
                )
              else ...[
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 10),
                        Text(
                          'Checkout confirmed',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: products
                        .asMap()
                        .entries
                        .map(
                          (entry) => ListTile(
                            leading: CircleAvatar(
                              child: Text('${entry.value.quantity}'),
                            ),
                            title: Text(entry.value.product.$2),
                            subtitle: Text(entry.value.product.$1),
                            trailing: Text(
                              '₱${entry.value.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
