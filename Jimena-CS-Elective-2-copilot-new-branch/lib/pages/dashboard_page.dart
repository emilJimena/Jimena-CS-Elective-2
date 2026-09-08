import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/crud_content.dart';
import '../widgets/discover_content.dart';
import '../widgets/orders_content.dart';
import '../widgets/sidebar.dart';

// Owns the selected navigation section and chooses the matching content view.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.onThemeToggle});
  final VoidCallback onThemeToggle;
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selected = 'Home';
  final List<CartItem> cart = [];
  final List<CartItem> orders = [];
  final nav = const ['Home', 'Orders'];
  final icons = const [Icons.home_outlined, Icons.receipt_long_outlined];

  void addToCart(Product product) {
    setState(() {
      CartItem? existing;
      for (final item in cart) {
        if (item.product == product) {
          existing = item;
          break;
        }
      }
      if (existing == null) {
        cart.add(CartItem(product: product));
      } else {
        existing.quantity++;
      }
    });
  }

  void updateCartQuantity(CartItem item) {
    setState(() {
      if (item.quantity <= 0) cart.remove(item);
    });
  }

  void checkout() {
    setState(() {
      orders.addAll(
        cart.map(
          (item) => CartItem(product: item.product, quantity: item.quantity),
        ),
      );
      cart.clear();
      selected = 'Orders';
    });
  }

  void showCart() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CartSheet(
        products: cart,
        onCheckout: checkout,
        onQuantityChanged: updateCartQuantity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compactAppBar = MediaQuery.sizeOf(context).width < 500;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'shopify',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: showCart,
            icon: Badge(
              isLabelVisible: cart.isNotEmpty,
              label: Text(
                '${cart.fold(0, (total, item) => total + item.quantity)}',
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onThemeToggle,
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          if (!compactAppBar) ...[
            const SizedBox(width: 5),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: .35)),
              ),
              child: const Text(
                'Apparel Retailer',
                style: TextStyle(fontSize: 11),
              ),
            ),
            const SizedBox(width: 12),
            const CircleAvatar(
              radius: 14,
              child: Text(
                'AR',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 13),
          ],
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 800;
          final sidebar = Sidebar(
            items: nav,
            icons: icons,
            selected: selected,
            onSelect: (item) => setState(() => selected = item),
          );
          // Home is the discovery view; the other sections use the reusable CRUD view.
          final content = selected == 'Home'
              ? DiscoverContent(onAddToCart: addToCart)
              : selected == 'Orders'
              ? OrdersContent(products: orders)
              : CrudContent(section: selected);
          if (compact) {
            return Column(
              children: [
                SizedBox(height: 58, child: sidebar),
                Expanded(child: content),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 124, child: sidebar),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }
}
