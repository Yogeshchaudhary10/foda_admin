import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Transaction History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payment_history')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to fetch payment history. Please try again.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final paymentHistory = snapshot.data?.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final dateTime = (data['dateTime'] as Timestamp?)?.toDate();
            return PaymentTransaction(
              id: doc.id,
              amount: (data['amount'] ?? 0.0).toDouble(),
              customerId: data['customerId'] ?? '',
              status: data['status'] ?? 'Unknown',
              dateTime: dateTime,
            );
          }).toList();

          if (paymentHistory == null || paymentHistory.isEmpty) {
            return const Center(
              child: Text('No payment history available.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: paymentHistory.length,
            itemBuilder: (context, index) {
              final transaction = paymentHistory[index];
              return buildTransactionCard(transaction, context);
            },
          );
        },
      ),
    );
  }

  Widget buildTransactionCard(
      PaymentTransaction transaction, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // color: Colors.white, // Set your desired background color
      child: ListTile(
        title: Text('Transaction ID: ${transaction.id}'),
        subtitle: Container(
          // color: Colors.grey[200], // Set your desired background color
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Amount: ${transaction.amount.toStringAsFixed(2)}'),
              const SizedBox(height: 4),
              // if (transaction.customerId.isNotEmpty)
              //   Text('Customer ID: ${transaction.customerId}'),
              const Text('Status: Complete'),
              // SizedBox(height: 4),
              // if (transaction.status.isNotEmpty)
              //   Text('Status: ${transaction.status}'),
              const SizedBox(height: 4),
              Text(
                'Date and Time: ${transaction.dateTime != null ? transaction.dateTime.toString() : 'N/A'}',
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        trailing: IconButton(
          color: Colors.red,
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Delete Transaction'),
                  content: const Text(
                    'Are you sure you want to delete this transaction?',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        deleteTransaction(transaction.id);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void deleteTransaction(String transactionId) {
    FirebaseFirestore.instance
        .collection('payment_history')
        .doc(transactionId)
        .delete()
        .then((value) {
      // Transaction deleted successfully
      print('Transaction deleted successfully');
    }).catchError((error) {
      // Failed to delete transaction
      print('Failed to delete transaction: $error');
    });
  }
}

class PaymentTransaction {
  final String id;
  final double amount;
  final String customerId;
  final String status;
  final DateTime? dateTime;

  PaymentTransaction({
    required this.id,
    required this.amount,
    required this.customerId,
    required this.status,
    required this.dateTime,
  });
}
