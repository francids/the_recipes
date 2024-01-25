class Recipe {
  String title;
  String description;
  String image;
  List<String> ingredients;
  List<String> directions;

  Recipe({
    required this.title,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.directions,
  });
}
