import 'dart:convert';
import 'package:equatable/equatable.dart';

class Food extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  const Food({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, title, description, imageUrl];
}

class FoodModel extends Food {
  final String category;
  final int price;
  final int createdAt;
  final int updatedAt;
  final bool isLive;
  final Map<String, dynamic> createdBy;
  final List<String> ingredients;

  const FoodModel({
    required String id,
    required String title,
    required String imageUrl,
    required String description,
    required this.category,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.isLive,
    required this.createdBy,
    required this.ingredients,
  }) : super(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
        );

  FoodModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? description,
    String? category,
    int? price,
    int? createdAt,
    int? updatedAt,
    bool? isLive,
    Map<String, dynamic>? createdBy,
    List<String>? ingredients,
  }) {
    return FoodModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLive: isLive ?? this.isLive,
      createdBy: createdBy ?? this.createdBy,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      price: map['price'] ?? 0,
      createdAt: map['createdAt'] ?? 0,
      updatedAt: map['updatedAt'] ?? 0,
      isLive: map['isLive'] ?? false,
      createdBy: Map<String, dynamic>.from(map['createdBy']),
      ingredients: List<String>.from(map['ingredients']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) =>
      FoodModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FoodModel(id: $id, title: $title, imageUrl: $imageUrl, description: $description, category: $category, price: $price, createdAt: $createdAt, updatedAt: $updatedAt, isLive: $isLive, createdBy: $createdBy, ingredients: $ingredients)';
  }

  @override
  List<Object?> get props {
    return [
      ...super.props,
      category,
      price,
      createdAt,
      updatedAt,
      isLive,
      createdBy,
      ingredients,
    ];
  }
}
