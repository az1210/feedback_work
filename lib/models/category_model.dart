class CategoryModel {
  final String? id;
  final String categoryTitle;
  final String? categoryIcon;
  CategoryModel({
    this.id,
    required this.categoryTitle,
    this.categoryIcon,
  });

  CategoryModel copyWith({
    String? id,
    String? categoryTitle,
    String? categoryIcon,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      categoryIcon: categoryIcon ?? this.categoryIcon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryTitle': categoryTitle,
      'categoryIcon': categoryIcon,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] != null ? map['id'] as String : null,
      categoryTitle: map['categoryTitle'] as String,
      categoryIcon:
          map['categoryIcon'] != null ? map['categoryIcon'] as String : null,
    );
  }
}
