import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms/services/firestore_service.dart';



class RequestVisitScreen extends StatefulWidget {
  @override
  _RequestVisitScreenState createState() => _RequestVisitScreenState();
}

class _RequestVisitScreenState extends State<RequestVisitScreen> {
  final _hostController = TextEditingController(text: "Santosh Gokle");
  final _timeController = TextEditingController(text: "12:00PM");
  final _dateController = TextEditingController(text: "29/08/2024");

  String? selectedCompany = "LTIMindtree";
  String? selectedPurpose = "Business Meeting";
  bool _isLoading = false; // Added for loading state

  final List<String> companies = ["LTIMindtree", "TCS", "Infosys"];
  final List<String> purposes = ["Business Meeting", "Interview", "Delivery"];

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Use current date as initial
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Use current time as initial
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  // --- New function to send data to Firestore ---
  // Future<void> _sendVisitRequest() async {
  //   setState(() {
  //     _isLoading = true; // Start loading
  //   });

  //   try {
  //     // Get a reference to the 'visit_requests' collection
  //     CollectionReference visitRequests =
  //         FirebaseFirestore.instance.collection('visit_requests');

  //     // Create a map of the data to be saved
  //     Map<String, dynamic> requestData = {
  //       'hostName': _hostController.text,
  //       'company': selectedCompany,
  //       'purpose': selectedPurpose,
  //       'visitDate': _dateController.text,
  //       'visitTime': _timeController.text,
  //       'status': 'Pending', // Initial status
  //       'createdAt': FieldValue.serverTimestamp(), // Add a server timestamp
  //     };

  //     // Add the data to Firestore
  //     await visitRequests.add(requestData);

  //     print("Visit request sent to Firestore successfully!");
      
  //     // Show success dialog and then reset state
  //     _showSuccessDialog();

  //   } catch (e) {
  //     print("Error sending visit request: $e");
  //     // Show an error message to the user
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Failed to send request. Please try again."),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false; // Stop loading
  //     });
  //   }
  // }
   // <-- make sure to import


final FirestoreService _firestoreService = FirestoreService(); // <-- Add this at top of your class

Future<void> _sendVisitRequest() async {
  setState(() => _isLoading = true);

  try {
    Map<String, dynamic> requestData = {
      'hostName': _hostController.text,
      'company': selectedCompany,
      'purpose': selectedPurpose,
      'visitDate': _dateController.text,
      'visitTime': _timeController.text,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestoreService.addVisit(requestData); // ✅ Call from service

    _showSuccessDialog();
  } catch (e) {
    print("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to send request."), backgroundColor: Colors.red),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                          // Close dialog and return to the previous screen (or home)
                          Navigator.of(context).pop(); 
                          Navigator.of(context).pop(); // Pops the RequestVisitScreen
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
                          // Add your View Details navigation here
                          // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => VisitDetailsScreen()));
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Request a Visit", style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Host Name"),
            _buildTextField(_hostController, readOnly: true),
            SizedBox(height: 16),

            _buildLabel("Company Name"),
            _buildDropdown(companies, selectedCompany, (val) {
              setState(() => selectedCompany = val);
            }),
            SizedBox(height: 16),

            _buildLabel("Purpose of Visit"),
            _buildDropdown(purposes, selectedPurpose, (val) {
              setState(() => selectedPurpose = val);
            }),
            SizedBox(height: 16),

            _buildLabel("Date"),
            _buildDateTimeField(_dateController, Icons.calendar_today, _selectDate),
            SizedBox(height: 16),

            _buildLabel("Time"),
            _buildDateTimeField(_timeController, Icons.access_time, _selectTime),
            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // Call the new function instead of the dialog directly
                onPressed: _isLoading ? null : _sendVisitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00C27C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white) // Show loading indicator
                    : Text("Register", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField(TextEditingController controller, {bool readOnly = false}) {
    return TextField(
      controller: controller,
      // readOnly: readOnly,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateTimeField(TextEditingController controller, IconData icon, VoidCallback onTap) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        suffixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}