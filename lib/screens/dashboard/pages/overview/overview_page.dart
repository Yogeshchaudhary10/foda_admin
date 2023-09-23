import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  int feedbackCount = 0;
  int foodsCount = 0;
  int paymentHistoryCount = 0;
  int usersCount = 0;
  bool isLoading = true; // Add loading indicator state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final feedbackSnapshot =
        await FirebaseFirestore.instance.collection('feedback').get();
    feedbackCount = feedbackSnapshot.docs.length;

    final foodsSnapshot =
        await FirebaseFirestore.instance.collection('foods').get();
    foodsCount = foodsSnapshot.docs.length;

    final paymentHistorySnapshot =
        await FirebaseFirestore.instance.collection('payment_history').get();
    paymentHistoryCount = paymentHistorySnapshot.docs.length;

    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    usersCount = usersSnapshot.docs.length;

    setState(() {
      isLoading = false; // Data has been fetched, set isLoading to false.
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: const Text("Overview"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Loading indicator
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child: _buildCountContainer(
                            title: 'Feedback',
                            count: feedbackCount,
                            icon: Icons.feedback,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          flex: 1,
                          child: _buildCountContainer(
                            title: 'Foods',
                            count: foodsCount,
                            icon: Icons.fastfood,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child: _buildCountContainer(
                            title: 'Payment History',
                            count: paymentHistoryCount,
                            icon: Icons.history,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          flex: 1,
                          child: _buildCountContainer(
                            title: 'Users',
                            count: usersCount,
                            icon: Icons.people,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCountContainer({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            " = ",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
