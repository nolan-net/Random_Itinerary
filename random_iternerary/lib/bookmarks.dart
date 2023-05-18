import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarksPage extends StatelessWidget {
  final String email;
  const BookmarksPage({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No user found with the given email.');
            } else {
              final userDoc = snapshot.data!.docs.first;
              final bookmarksRef = userDoc.reference.collection('bookmarks');
              return StreamBuilder<QuerySnapshot>(
                stream: bookmarksRef.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No bookmarks found.');
                  } else {
                    final bookmarkDocs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: bookmarkDocs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final bookmarkDoc = bookmarkDocs[index];
                        final bookmarkData = bookmarkDoc.data() as Map<String, dynamic>?;
                        final title = bookmarkData?['title'] as String? ?? 'No Title';
                        final address = bookmarkData?['address'] as String? ?? 'No Address';
                        return SizedBox(
                          width: double.infinity,
                          child: Card(
                            child: ListTile(
                              title: Text(title),
                              subtitle: Text(address),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}