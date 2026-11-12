import 'package:cs_elective_2/models/product_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductFilter', () {
    test('tracks a price range and active state', () {
      const filter = ProductFilter(
        search: 'shoe',
        categoryId: 2,
        minPrice: 150,
        maxPrice: 500,
        page: 2,
        pageSize: 6,
      );

      expect(filter.minPrice, 150);
      expect(filter.maxPrice, 500);
      expect(filter.page, 2);
      expect(filter.pageSize, 6);
      expect(filter.isActive, isTrue);
    });

    test('resets values to defaults', () {
      const filter = ProductFilter();

      expect(filter.search, isEmpty);
      expect(filter.categoryId, isNull);
      expect(filter.minPrice, isNull);
      expect(filter.maxPrice, isNull);
      expect(filter.page, 1);
      expect(filter.pageSize, 6);
      expect(filter.isActive, isFalse);
    });
  });
}
