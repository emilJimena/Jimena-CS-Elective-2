import 'package:cs_elective_2/models/product_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductFilterNotifier extends Notifier<ProductFilter> {
  @override
  ProductFilter build() {
    return const ProductFilter();
  }

  void setSearch(String search) {
    state = ProductFilter(
      search: search,
      categoryId: state.categoryId,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      page: 1,
      pageSize: state.pageSize,
    );
  }

  void setCategoryId(int? categoryId) {
    state = ProductFilter(
      search: state.search,
      categoryId: categoryId,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      page: 1,
      pageSize: state.pageSize,
    );
  }

  void setPriceRange({double? minPrice, double? maxPrice}) {
    state = ProductFilter(
      search: state.search,
      categoryId: state.categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      page: 1,
      pageSize: state.pageSize,
    );
  }

  void setPage(int page) {
    final nextPage = page < 1 ? 1 : page;
    state = ProductFilter(
      search: state.search,
      categoryId: state.categoryId,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      page: nextPage,
      pageSize: state.pageSize,
    );
  }

  void reset() => state = const ProductFilter();
}

final productFilterProvider =
    NotifierProvider<ProductFilterNotifier, ProductFilter>(
      ProductFilterNotifier.new,
    );
