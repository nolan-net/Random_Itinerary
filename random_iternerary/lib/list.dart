  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'dart:convert';
  
  class ListPage extends StatefulWidget {
    final String email;
  
    const ListPage({required this.email, Key? key}) : super(key: key);
  
    @override
    _ListPageState createState() => _ListPageState();
  }
  
  class _ListPageState extends State<ListPage> {
    List<String> expandedLists = [];
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('List'),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.email)
                .collection('lists')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No lists found.');
              } else {
                final listDocs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: listDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final listDoc = listDocs[index];
                    final listData = listDoc.data() as Map<String, dynamic>?;
                    final listName = listDoc.id;
                    final jsonString = listData?['jsonString'] as String?;
                    final titles = jsonString != null ? List<String>.from(jsonDecode(jsonString)) : [];
  
                    return Card(
                      child: ListTile(
                        title: Text(
                          listName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (expandedLists.contains(listName)) {
                              expandedLists.remove(listName);
                            } else {
                              expandedLists.add(listName);
                            }
                          });
                        },
                        subtitle: expandedLists.contains(listName)
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: titles
                              .map(
                                (title) => Text(title),
                          )
                              .toList(),
                        )
                            : null,
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      );
    }
  }
