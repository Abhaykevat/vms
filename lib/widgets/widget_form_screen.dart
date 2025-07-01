// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class VisitFormScreen extends StatelessWidget {
//   final nameController = TextEditingController();
//   final hostController = TextEditingController();
//   final purposeController = TextEditingController();

//   void submitVisit() {
//     FirebaseFirestore.instance.collection("visits").add({
//       "visitorName": nameController.text,
//       "hostName": hostController.text,
//       "purpose": purposeController.text,
//       "status": "Pending",
//       "timestamp": FieldValue.serverTimestamp(),
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Register Visit")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(children: [
//           TextField(controller: nameController, decoration: InputDecoration(labelText: "Visitor Name")),
//           TextField(controller: hostController, decoration: InputDecoration(labelText: "Host Name")),
//           TextField(controller: purposeController, decoration: InputDecoration(labelText: "Purpose")),
//           ElevatedButton(
//             onPressed: submitVisit,
//             child: Text("Submit Visit"),
//           ),
//         ]),
//      ),
// );
// }
// }