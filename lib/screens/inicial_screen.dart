import 'package:the_recipes/screens/add_recipe_screen.dart';
import 'package:the_recipes/widgets/recipe_card.dart';
import 'package:the_recipes/models/recipe.dart';
import 'package:flutter/material.dart';

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

class _InicialScreenState extends State<InicialScreen> {
  List<Recipe> recipes = [
    Recipe(
      title: "Spaghetti with Tomato",
      image:
          "https://cdn2.cocinadelirante.com/sites/default/files/styles/gallerie/public/images/2016/08/spaguetti.jpg",
      description:
          "Spaghetti with Tomato Sauce and Mushrooms is a simple spaghetti recipe with classic flavors!",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the carbonara with several turns of freshly ground black pepper and taste for salt. Mound the spaghetti carbonara into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
    Recipe(
      title: "Pesto Pasta",
      image:
          "https://www.kitchensanctuary.com/wp-content/uploads/2023/07/Pesto-Pasta-square-FS.jpg",
      description:
          "Pesto Pasta is creamy, flavorful and ready in just 10 minutes! This easy pasta recipe is loaded with chicken, tomatoes, pesto, and mozzarella cheese.",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the carbonara with several turns of freshly ground black pepper and taste for salt. Mound the spaghetti carbonara into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
    Recipe(
      title: "Chicken Parmesan",
      image:
          "https://tastesbetterfromscratch.com/wp-content/uploads/2023/03/Chicken-Parmesan-1.jpg",
      description:
          "Chicken Parmesan is a classic Italian dish made with breaded chicken cutlets, marinara sauce, and lots of cheese. It’s an easy dinner recipe the whole family will love!",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the carbonara with several turns of freshly ground black pepper and taste for salt. Mound the spaghetti carbonara into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
    Recipe(
      title: "Chicken Alfredo",
      image:
          "https://www.budgetbytes.com/wp-content/uploads/2022/07/Chicken-Alfredo-bowl.jpg",
      description:
          "Chicken Alfredo is an easy pasta dish made with homemade Alfredo sauce and fettuccine noodles. This creamy and cheesy dish is loaded with chicken breast making it a satisfying and delicious meal for the entire family.",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the carbonara with several turns of freshly ground black pepper and taste for salt. Mound the spaghetti carbonara into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
    Recipe(
      title: "Chicken Noodle Soup",
      image:
          "https://hips.hearstapps.com/hmg-prod/images/chicken-noodle-soup-index-644c2bec1ce0c.jpg",
      description:
          "Chicken Noodle Soup is a classic soup recipe made with chicken, carrots, celery, onion, and egg noodles in a seasoned broth, ready in under 45 minutes!",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the carbonara with several turns of freshly ground black pepper and taste for salt. Mound the spaghetti carbonara into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
    Recipe(
      title: "Arroz con leche",
      image: "https://img.bekiacocina.com/cocina/0000/96-h.jpg",
      description:
          "El arroz con leche es un postre tradicional de la gastronomía de muchos países. Se trata de un postre de arroz cocido en leche con azúcar y canela.",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the carbonara with several turns of freshly ground black pepper and taste for salt. Mound the spaghetti carbonara into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
    Recipe(
      title: "Tacos",
      image:
          "https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg",
      description:
          "Los tacos son un plato típico de la gastronomía mexicana que consiste en una tortilla de maíz o de trigo que contiene un alimento dentro.",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the carbonara with several turns of freshly ground black pepper and taste for salt. Mound the spaghetti carbonara into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
    Recipe(
      title: "Pizza",
      image:
          "https://www.recipetineats.com/wp-content/uploads/2023/05/Garlic-cheese-pizza_9.jpg",
      description:
          "La pizza es un plato de origen italiano, específicamente de Nápoles. Se trata de un disco de masa de harina de trigo, levadura, agua y sal, cubierto con salsa de tomate y otros ingredientes como queso, jamón, cebolla, champiñones, etc.",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the carbonara with several turns of freshly ground black pepper and taste for salt. Mound the spaghetti carbonara into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
    Recipe(
      title: "Hamburguesa",
      image:
          "https://d31npzejelj8v1.cloudfront.net/media/recipemanager/recipe/1687289598_doble-carne.jpg",
      description:
          "La hamburguesa es un tipo de sándwich elaborado a base de carne picada aglutinada en forma de filete cocinado a la parrilla o a la plancha, aunque también puede freírse u hornearse.",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the carbonara with several turns of freshly ground black pepper and taste for salt. Mound the spaghetti carbonara into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
    Recipe(
      title: "Hot Dog",
      image:
          "https://www.gardengourmet.com/sites/default/files/recipes/83393badc124840730cb91e3cd839b93_220516_gg_q3_recipe_hotdogs_v3.jpg",
      description:
          "El hot dog es un tipo de sándwich elaborado a base de carne picada aglutinada en forma de filete cocinado a la parrilla o a la plancha, aunque también puede freírse u hornearse.",
      ingredients: <String>[
        "1 pound spaghetti",
        "2 tablespoons extra-virgin olive oil",
        "1/4 pound pancetta or slab bacon, cubed or sliced into small strips",
        "4 garlic cloves, finely chopped",
        "2 large eggs",
        "1 cup freshly grated Parmigiano-Reggiano, plus more for serving",
        "Freshly ground black pepper",
        "1 handful fresh flat-leaf parsley, chopped",
      ],
      directions: <String>[
        "Bring a large pot of salted water to a boil, add the pasta and cook for 8 to 10 minutes or until tender yet firm (as they say in Italian \"al dente.\") Drain the pasta well, reserving 1/2 cup of the starchy cooking water to use in the sauce if you wish.",
        "Meanwhile, heat the olive oil in a deep skillet over medium flame. Add the pancetta and saute for about 3 minutes, until the bacon is crisp and the fat is rendered. Toss the garlic into the fat and saute for less than 1 minute to soften.",
        "Add the hot, drained spaghetti to the pan and toss for 2 minutes to coat the strands in the bacon fat. Beat the eggs and Parmesan together in a mixing bowl, stirring well to prevent lumps. Remove the pan from the heat and pour the egg/cheese mixture into the pasta, whisking quickly until the eggs thicken, but do not scramble (this is done off the heat to ensure this does not happen.) Thin out the sauce with a bit of the reserved pasta water, until it reaches desired consistency. Season the hot dog with several turns of freshly ground black pepper and taste for salt. Mound the hot dog into warm serving bowls and garnish with chopped parsley. Pass more cheese around the table.",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Recipes App',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddRecipeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Agregar Receta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            indent: 16,
            endIndent: 16,
            thickness: 0.6,
            color: Colors.black12,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: RecipeCard(
                    recipe: recipes[index],
                    index: index, // Esto es para el Hero (Animación)
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
