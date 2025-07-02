
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms/services/firestore_service.dart';

class VisitRequestProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController hostController = TextEditingController(text: "Santosh Gokle");
  final TextEditingController timeController = TextEditingController(text: "12:00PM");
  final TextEditingController dateController = TextEditingController(text: "29/08/2024");

  String? selectedCompany = "LTIMindtree";
  String? selectedPurpose = "Business Meeting";

  bool isLoading = false;

  List<String> companies = ["LTIMindtree", "TCS", "Infosys"];
  List<String> purposes = ["Business Meeting", "Interview", "Delivery"];

  void setCompany(String? value) {
    selectedCompany = value;
    notifyListeners();
  }

  void setPurpose(String? value) {
    selectedPurpose = value;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateController.text = "${picked.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      notifyListeners();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      timeController.text = picked.format(context);
      notifyListeners();
    }
  }

  Future<void> sendVisitRequest(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final requestData = {
        'hostName': hostController.text,
        'company': selectedCompany,
        'purpose': selectedPurpose,
        'visitDate': dateController.text,
        'visitTime': timeController.text,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestoreService.addVisit(requestData);

      isLoading = false;
      notifyListeners();
      _showSuccessDialog(context);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send request."), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Color(0xFFF1FFFA),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 50, color: Color(0xFF00C27C)),
              SizedBox(height: 16),
              Text("Request Sent!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                "You will be notified once the host approves your request.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00C27C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text("Close", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text("View Details", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
