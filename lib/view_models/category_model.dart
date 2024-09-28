class Category {
  final String categoryId;
  final String name;
  final String description;

  Category(
      {required this.categoryId,
      required this.name,
      required this.description});

  // Convert ProductItem object to JSON
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description
    };
  }

  // Factory method to create a ProductItem object from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'],
      description: json['description']
    );
  }
}
