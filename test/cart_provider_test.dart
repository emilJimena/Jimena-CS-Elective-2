import 'package:cs_elective_2/models/product.dart';
import 'package:cs_elective_2/providers/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartProvider CRUD', () {
    test('adds, updates, and removes a product', () {
      final container = ProviderContainer();
      final product = Product(
        id: 1,
        name: 'Headphones',
        price: 299.99,
        stock: 10,
        imageUrl: '',
        categoryId: 1,
      );

      final notifier = container.read(cartProvider.notifier);
      notifier.addToCart(product);

      expect(container.read(cartProvider).length, 1);
      expect(container.read(cartProvider).first.quantity, 1);

      notifier.updateQuantity(1, 3);
      expect(container.read(cartProvider).first.quantity, 3);
      expect(container.read(cartProvider).fold<double>(0, (sum, item) => sum + item.total), 899.97);

      notifier.removeFromCart(1);
      expect(container.read(cartProvider), isEmpty);
    });
  });
}
