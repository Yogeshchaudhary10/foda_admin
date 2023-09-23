import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/models/food.dart';
import 'package:foda_admin/repositories/food_repository.dart';
import 'package:foda_admin/themes/app_theme.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FoodsPage extends StatefulWidget {
  const FoodsPage({Key? key}) : super(key: key);

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  List<FoodModel> foods = [];

  @override
  void initState() {
    super.initState();
    _fetchFoods();
  }

  Future<void> _fetchFoods() async {
    final result = await FoodRepository().getFood();
    if (result.isNotEmpty) {
      setState(() {
        foods = result
            .map((data) => FoodModel(
                  id: data['id'],
                  title: data['title'],
                  description: data['description'],
                  imageUrl: data['imageUrl'],
                  category: '', // Add the appropriate value
                  createdAt: 123, // Add the appropriate value
                  isLive: true,
                  createdBy: const {}, // Add the appropriate value
                  ingredients: const [], // Add the appropriate value
                  price: data[
                      'price'], // Assuming 'price' field exists in the data
                  updatedAt: data[
                      'updatedAt'], // Assuming 'updatedAt' field exists in the dat
                ))
            .toList();
      });
    }
  }

  Future<void> _deleteFood(int index) async {
    final isSuccess = await FoodRepository().deleteFood(foods[index]);
    if (isSuccess) {
      setState(() {
        foods.removeAt(index);
      });
    } else {
      // Failed to delete food item
      print('Failed to delete food item: ${foods[index].id}');
    }
  }

  Future<void> _editFood(int index) async {
    final editedFood = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditFoodPage(food: foods[index])),
    );
    if (editedFood != null) {
      final isSuccess = await FoodRepository().updateFood(editedFood);
      if (isSuccess) {
        setState(() {
          foods[index] = editedFood;
        });
      } else {
        // Failed to update food item
        print('Failed to update food item: ${editedFood.id}');
      }
    }
  }

  Future<String> _getDownloadURL(String imagePath) async {
    final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
    final downloadURL = await ref.getDownloadURL();
    print('Download URL for $imagePath: $downloadURL');
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: const Text("Foods"),
      ),
      body: ListView.builder(
        itemCount: foods.length,
        padding: const EdgeInsets.only(bottom: AppTheme.cardPadding),
        itemBuilder: (context, index) {
          final FoodModel food = foods[index];

          return GestureDetector(
            onTap: () {
              _editFood(index);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  FutureBuilder<String>(
                    future: _getDownloadURL(food.imageUrl),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.data == null) {
                        return const Text('Download URL is null');
                      }
                      print('Image URL for ${food.imageUrl}: ${snapshot.data}');
                      return Image.network(
                        snapshot.data!,
                        height: 200,
                        width: 50,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  const SizedBox(
                    width: AppTheme.elementSpacing,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          food.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteFood(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditFoodPage extends StatefulWidget {
  final FoodModel food;

  const EditFoodPage({Key? key, required this.food}) : super(key: key);

  @override
  _EditFoodPageState createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.food.title;
    _descriptionController.text = widget.food.description;
    _priceController.text = widget.food.price.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final editedFood = widget.food.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      price: int.parse(_priceController.text),
    );

    final isSuccess = await FoodRepository().updateFood(editedFood);

    if (isSuccess) {
      Navigator.pop(context, editedFood);
    } else {
      print('Failed to update food item in Firebase: ${editedFood.id}');
      // You can show an error message to the user if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Food'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveChanges,
              style: const ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
