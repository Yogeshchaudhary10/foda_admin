import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            final orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                final order = orders[index].data() as Map<String, dynamic>;

                // Extracting data from the document
                final cartItemCount = order['cart_item_count'] as int?;
                final foodName = order['food_name'] as String?;
                // final foodNames = order['food_name'] as List<dynamic>?;
                final foodPrice = order['food_price'] as int?;
                final location = order['location'] as String?;
                final timestamp = order['timestamp'] as Timestamp?;
                final totalSum = order['total_sum'] as int?;

                return Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text('Order ${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Food Names:$foodName'),
                        // for (var foodName in foodNames!) Text('- $foodName'),
                        Text('Price: $foodPrice'),
                        Text('Location: $location'),
                        Text('Timestamp: ${timestamp?.toDate()}'),
                        Text('Total Sum: $totalSum'),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Text('No orders found.');
        },
      ),
    );
  }
}
