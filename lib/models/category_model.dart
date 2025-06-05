class CategoryModel {
  final String id;
  final String categoryTitle;
  final String categoryIcon;
  final DateTime? createdAt;

  CategoryModel({
    this.id = '',
    this.categoryTitle = '',
    this.categoryIcon = '',
    this.createdAt,
  });

  CategoryModel copyWith({
    String? id,
    String? categoryTitle,
    String? categoryIcon,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_title': categoryTitle,
      'category_icon': categoryIcon,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toString() ?? '',
      categoryTitle: map['category_title']?.toString() ?? '',
      categoryIcon: map['category_icon']?.toString() ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'].toString())
          : null,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, categoryTitle: $categoryTitle, categoryIcon: $categoryIcon, createdAt: $createdAt)';
  }
}
