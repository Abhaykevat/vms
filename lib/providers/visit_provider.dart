
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms/services/firestore_service.dart';

class VisitProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<QuerySnapshot> get visitsStream => _firestoreService.getVisits();

  Future<void> updateStatus(String docId, String status, BuildContext context) async {
    try {
      await _firestoreService.updateVisitStatus(docId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status updated to '$status'")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating status"), backgroundColor: Colors.red),
      );
    }
  }
}
