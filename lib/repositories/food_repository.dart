import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:foda_admin/utils/common.dart';
import '../models/food.dart';
import '../models/result.dart';

class FoodRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _foodsCollection =
      FirebaseFirestore.instance.collection('foods');
  final ValueNotifier<List<FoodModel>> foodsNotifier =
      ValueNotifier<List<FoodModel>>([]);

  Future<Either<ErrorHandler, bool>> addFood(FoodModel food) async {
    try {
      await _foodsCollection.doc(food.id).set(food.toMap());
      return const Right(true);
    } catch (e) {
      return Left(ErrorHandler(message: e.toString()));
    }
  }

  Future<List<dynamic>> getFood() async {
    List<dynamic> foodList = [];
    try {
      final QuerySnapshot snapshot = await _foodsCollection.get();
      for (var doc in snapshot.docs) {
        foodList.add(doc.data());
      }
      return foodList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<FoodModel>> loadFoods() async {
    try {
      final QuerySnapshot snapshot = await _foodsCollection.get();
      final List<FoodModel> foodList = snapshot.docs
          .map((doc) => FoodModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return foodList;
    } catch (e) {
      fodaPrint(e);
      return [];
    }
  }

  Future<bool> deleteFood(FoodModel food) async {
    try {
      await _foodsCollection.doc(food.id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateFood(FoodModel food) async {
    try {
      await _foodsCollection.doc(food.id).update(food.toMap());
      return true;
    } catch (e) {
      print('Error updating food: $e');
      return false;
    }
  }
}
