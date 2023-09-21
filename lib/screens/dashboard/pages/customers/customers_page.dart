import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';

class Customer {
  final String name;
  final String email;
  final String phone;
  final String location;

  Customer({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
  });
}

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<Customer> customers = [];

  Future<List<Customer>> getCustomers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final customers = snapshot.docs.map((document) {
      final data = document.data();
      return Customer(
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        location: data['location'] ?? '',
      );
    }).toList();

    return customers;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: const Text("Customers"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Customer>>(
        future: getCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          customers = snapshot.data ?? [];

          if (customers.isEmpty) {
            return const Text('No customers found.');
          }

          final totalCustomers = customers.length;

          return Column(
            children: [
              Text('Total Customers: $totalCustomers'),
              Expanded(
                child: Center(
                  child: ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${customer.name}'),
                              Text('Email: ${customer.email}'),
                              Text('Phone: ${customer.phone}'),
                              Text('Location: ${customer.location}'),
                            ],
                          ),
                          tileColor: Colors.grey[100],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
