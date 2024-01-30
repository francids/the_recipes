class Recipe {
  String id;
  String title;
  String description;
  String image;
  List<String> ingredients;
  List<String> directions;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.directions,
  })  : assert(ingredients.isNotEmpty),
        assert(directions.isNotEmpty);

  Recipe.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? '',
        title = map['title'] ?? '',
        description = map['description'] ?? '',
        image = map['image'] ?? '',
        ingredients = List<String>.from(map['ingredients'] ?? []),
        directions = List<String>.from(map['directions'] ?? []) {
    assert(ingredients.isNotEmpty);
    assert(directions.isNotEmpty);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'ingredients': ingredients,
      'directions': directions,
    };
  }
}
