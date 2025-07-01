import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  
  CollectionReference get _visits => _db.collection('visit_requests');

  
  Stream<QuerySnapshot> getVisits() {
    return _visits.orderBy('createdAt', descending: true).snapshots();
  }
  Future<void> updateVisitStatus(String docId, String newStatus) async {
    try {
      await _visits.doc(docId).update({
        'status': newStatus,
      });
    } catch (e) {
      print("Error updating status: $e");
      rethrow;
    }
  }

  
  Future<void> addVisit(Map<String, dynamic> requestData) async {
    try {
      await _visits.add(requestData);
    } catch (e) {
      print("Error adding visit: $e");
      rethrow;
    }
  }
}
