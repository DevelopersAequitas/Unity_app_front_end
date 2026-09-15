class FlatOpenCategoryItem {
  final String id;
  final String name;
  final String sectorName;
  final String? subcategoryName;

  const FlatOpenCategoryItem({
    required this.id,
    required this.name,
    required this.sectorName,
    this.subcategoryName,
  });
}
