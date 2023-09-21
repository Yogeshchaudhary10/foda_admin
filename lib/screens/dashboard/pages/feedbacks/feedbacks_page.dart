import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foda_admin/components/app_scaffold.dart';

class FeedbacksPage extends StatelessWidget {
  const FeedbacksPage({Key? key}) : super(key: key);

  Future<void> _deleteFeedback(BuildContext context, String feedbackId) async {
    try {
      if (feedbackId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('feedback')
            .doc(feedbackId)
            .delete();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid feedback ID. Please try again.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to delete feedback. Please try again.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: const Text("Feedbacks"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No feedback available.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              if (!document.exists) {
                return ListTile(
                  title: const Text('Feedback not found'),
                );
              }
              final Map<String, dynamic>? feedbackData =
                  document.data() as Map<String, dynamic>?;
              final String feedbackId = document.id;
              final String feedback = feedbackData?['feedback'] ?? '';
              final String userId = feedbackData?['userId'] ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(feedback),
                      subtitle: const Text('Loading user information...'),
                    );
                  }

                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text(feedback),
                      subtitle: Text(
                        'Failed to fetch user information: ${userSnapshot.error}',
                      ),
                    );
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return ListTile(
                      title: Text(feedback),
                      subtitle: const Text('User not found'),
                    );
                  }

                  final Map<String, dynamic>? userData =
                      userSnapshot.data?.data() as Map<String, dynamic>?;
                  final String userName = userData?['name'] ?? '';
                  final String userEmail = userData?['email'] ?? '';

                  return ListTile(
                    title: Text(feedback),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: $userName'),
                        Text('Email: $userEmail'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteFeedback(context, feedbackId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
