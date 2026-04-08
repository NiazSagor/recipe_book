import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/ui/components/recipe_grid_card.dart';
import 'package:recipe_book/ui/provider/recipe_provider.dart';
import 'package:recipe_book/ui/saved_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    Future.microtask(
      () => context.read<RecipeProvider>().fetchPopularRecipes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back!",
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      const Text(
                        "Omar Calzoni",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _headerIcon(Icons.search),
                      const SizedBox(width: 15),
                      _headerIcon(
                        Icons.notifications_none,
                        hasNotification: true,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- Categories ---
              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _categoryChip("All", isActive: true),
                    _categoryChip("Breakfast"),
                    _categoryChip("Lunch"),
                    _categoryChip("Dinner"),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- Popular Recipes ---
              const Text(
                "Popular Recipes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: provider.popularRecipes.length.clamp(0, 2),
                      itemBuilder: (context, index) => RecipeGridCard(
                        recipe: provider.popularRecipes[index],
                      ),
                    ),

              const SizedBox(height: 30),

              // --- Recipes of The Week ---
              const Text(
                "Recipes of The Week",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              // List of vertical recipes
              ...provider.popularRecipes
                  .skip(2)
                  .map((recipe) => RecipeListTile(recipe: recipe))
                  .toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _customBottomNavBar(context),
    );
  }

  // --- UI Helper Widgets ---

  Widget _headerIcon(IconData icon, {bool hasNotification = false}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24),
        ),
        if (hasNotification)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _categoryChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: isActive ? Colors.orange : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey[400],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _customBottomNavBar(BuildContext context) {
    return BottomAppBar(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.home_filled, color: Colors.orange),
          const Icon(Icons.calendar_month, color: Colors.grey),
          // ... Scanner button ...
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedRecipesScreen(),
                ),
              );
            },
          ),
          const Icon(Icons.person, color: Colors.grey),
        ],
      ),
    );
  }
}
