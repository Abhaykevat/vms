
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms/services/firestore_service.dart';

class VisitLogProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<QuerySnapshot> get visitsStream => _firestoreService.getVisits();
}
