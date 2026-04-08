import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/ui/home_screen.dart';
import 'package:recipe_book/ui/provider/recipe_provider.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // MultiProvider allows you to add more providers (like Auth or Theme) later
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecipeProvider())],
      child: const RecipeBookApp(),
    ),
  );
}

class RecipeBookApp extends StatelessWidget {
  const RecipeBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.orange,
        // Using a clean font like Poppins or Inter makes the UI look professional
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
