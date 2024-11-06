class PaginatedResponse<T> {
  int? page;
  int? perPage;
  int? totalItems;
  int? totalPages;
  List<T>? items;

  PaginatedResponse({
    this.page,
    this.perPage,
    this.totalItems,
    this.totalPages,
    this.items,
  });

  bool get isLastPage => page == totalPages;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      page: json['page'],
      perPage: json['perPage'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      items: List<T>.from((json['items'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))),
    );
  }

  PaginatedResponse<T> copyWithAddItems({
    int? page,
    int? perPage,
    int? totalItems,
    int? totalPages,
    required List<T> items,
  }) {
    return PaginatedResponse(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      items: this.items?..addAll(items),
    );
  }

  PaginatedResponse<T> copyWithUpdateItem(List<T> items) {
    return PaginatedResponse(
      page: page,
      perPage: perPage,
      totalItems: totalItems,
      totalPages: totalPages,
      items: items,
    );
  }
}
