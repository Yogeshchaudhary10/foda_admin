import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

const String firebaseStoragePath =
    'foods'; // Adjust the path to your Firebase Storage location

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({Key? key}) : super(key: key);

  @override
  _CreateCategoryPageState createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  late Future<List<String>> availableFoods;

  @override
  void initState() {
    super.initState();
    availableFoods = fetchAvailableFoods();
  }

  Future<List<String>> fetchAvailableFoods() async {
    try {
      final result = await firebase_storage.FirebaseStorage.instance
          .ref(firebaseStoragePath)
          .listAll();
      final List<String> foodUrls =
          await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
      return foodUrls;
    } catch (e) {
      // Handle the error gracefully
      print('Error fetching available foods: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: const Text("Food Category"),
      ),
      body: FutureBuilder<List<String>>(
        future: availableFoods,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while fetching the data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle the error state
            return const Center(child: Text('Error fetching available foods'));
          } else {
            final foodUrls = snapshot.data ?? [];
            return ListView.builder(
              itemCount: foodUrls.length,
              itemBuilder: (context, index) {
                return Image.network(foodUrls[index]);
              },
            );
          }
        },
      ),
    );
  }
}
