class GetInventoryItemsParam {
  String? keyword;
  String? category;
  int page = 1;

  GetInventoryItemsParam({
    this.keyword,
    this.category,
    required this.page,
  });
}
