import 'package:flutter/material.dart';
import 'package:foda_admin/repositories/food_repository.dart';
import 'package:foda_admin/services/get_it.dart';

import '../../../../models/food.dart';

class FoodPageState extends ChangeNotifier {
  final foodRepo = locate<FoodRepository>();
  List<FoodModel> foods = [];

  FoodPageState() {
    _foodListener();
    foodRepo.foodsNotifier.addListener(_foodListener);
  }

  void _foodListener() {
    foods = foodRepo.foodsNotifier.value;
    notifyListeners();
  }
}
