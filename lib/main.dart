// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use
import 'package:flutter/material.dart';

import './dummy_categories.dart';

import './screen/filter_screen.dart';
import './screen/tabs_screen.dart';
import './screen/meal_detail_screen.dart';
import './screen/categories_meal_screen.dart';
import './screen/categories_screen.dart';

import './models/meal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegeterian': false,
    'vegan': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    _filters = filterData;

    _availableMeals = DUMMY_MEALS.where((meal) {
      if (_filters['gluten'] == true && !meal.isGlutenFree) {
        return false;
      }
      if (_filters['lactose'] == true && !meal.isLactoseFree) {
        return false;
      }
      if (_filters['vegeterian'] == true && !meal.isVegetarian) {
        return false;
      }
      if (_filters['vegan'] == true && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
  }

  void _toggleFavorite(String mealId) {
    final existingIndex =
        _favouriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favouriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favouriteMeals.add(
          DUMMY_MEALS.firstWhere((meal) => meal.id == mealId),
        );
      });
    }
  }

  bool _isMealFavorite(String mealId) {
    return _favouriteMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deli Meals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              subtitle1: TextStyle(
                fontSize: 24,
                fontFamily: 'RobotoCondenced',
              ),
            ),
      ),
      //home: CategoriesScreen(),
      routes: {
        '/': (ctx) => TabsScreen(_favouriteMeals),
        CategoryMealScreen.routeName: (ctx) =>
            CategoryMealScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(_toggleFavorite, _isMealFavorite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen(),
        );
      },
    );
  }
}
