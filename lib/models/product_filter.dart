class ProductFilter {
  final String search;
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final int page;
  final int pageSize;

  const ProductFilter({
    this.search = '',
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.page = 1,
    this.pageSize = 6,
  });

  int get offset => (page - 1) * pageSize;

  bool get isActive =>
      search.trim().isNotEmpty ||
      categoryId != null ||
      minPrice != null ||
      maxPrice != null;
}
