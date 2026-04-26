import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Filee extends StatefulWidget {
  const Filee({super.key});

  @override
  State<Filee> createState() => _FileeState();
}

class _FileeState extends State<Filee> {
  String jsonText = "Press button to load data";

  // 🔥 Fetch Firestore and convert to JSON string
  Future<void> printFirestoreAsJson() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('users').get();

  Map<String, dynamic> jsonData = {};

  for (var doc in snapshot.docs) {
    jsonData[doc.id] = doc.data();
  }

  String realJson = jsonEncode(jsonData); // ✅ REAL JSON

  print(realJson);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore JSON Viewer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: printFirestoreAsJson,
              child: const Text("Load Firestore Data"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  jsonText,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}