// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:vms/screens/admin_dashboard.dart';
// import 'package:vms/screens/request.dart';


// class EmployeeScreen extends StatelessWidget {
//   const EmployeeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Employee Screen'),
//       ),
//       body: const Center(
//         child: Text('Welcome, Employee!'),
//       ),
//     );
//   }
// }



// class DefineYourselfScreen extends StatefulWidget {
//   const DefineYourselfScreen({super.key});

//   @override
//   State<DefineYourselfScreen> createState() => _DefineYourselfScreenState();
// }

// class _DefineYourselfScreenState extends State<DefineYourselfScreen> {
//   String? _selectedRole;
//   bool _isLoading = false; // Add a loading state for the button

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent, // Transparent app bar
//         elevation: 0, // No shadow
//         title: const Text(
//           'Define Yourself',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     _buildRoleCard(
//                       context,
//                       'assets/id-card.png',
//                       'Visitor',
//                       'A temporary guest accessing the workspace for a specific purpose.',
//                     ),
//                     const SizedBox(height: 30),
//                     _buildRoleCard(
//                       context,
//                       'assets/employee.png',
//                       'Employee',
//                       'A regular member working within the shared office space.',
//                     ),
//                     const SizedBox(height: 30),
//                     _buildRoleCard(
//                       context,
//                       'assets/unauthorized-person.png',
//                       'Admin',
//                       'The manager overseeing visitors and workspace operations.',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity, // Make button full width
//               height: 50, // Set a fixed height for the button
//               child: ElevatedButton(
//                 onPressed: _selectedRole != null && !_isLoading
//                     ? () async {
//                         setState(() {
//                           _isLoading = true; // Show loading indicator
//                         });
//                         await _saveRoleAndNavigate(context);
//                         setState(() {
//                           _isLoading = false; // Hide loading indicator
//                         });
//                       }
//                     : null, // Disable button if no role is selected or is loading
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF26A69A), // Teal color for button
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12), // Rounded corners
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(
//                         color: Colors.white,
//                       )
//                     : const Text(
//                         'Next',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleCard(
//       BuildContext context, String imageUrl, String title, String description) {
//     bool isSelected = _selectedRole == title;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedRole = title;
//         });
//       },
//       child: Card(
//         elevation: isSelected ? 8 : 2, // Highlight the selected card
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16), // Rounded corners for the card
//           side: isSelected
//               ? const BorderSide(color: Color(0xFF26A69A), width: 3)
//               : BorderSide.none, // Add a border to the selected card
//         ),
//         margin: EdgeInsets.zero, // Remove default card margin
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Icon/Image section
//               Container(
//                 width: 80, // Fixed width for the image container
//                 height: 80, // Fixed height for the image container
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12), // Rounded corners for the image container
//                 ),
//                 child: Image.asset(
//                   imageUrl,
//                   fit: BoxFit.contain, // Adjust image fit
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Icon(
//                       Icons.image_not_supported,
//                       size: 60,
//                       color: Colors.grey,
//                     ); // Fallback icon
//                   },
//                 ),
//               ),
//               const SizedBox(width: 20), // Spacing between image and text
//               // Text content section
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       description,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Checkmark for selected card
//               if (isSelected)
//                 const Icon(
//                   Icons.check_circle,
//                   color: Color(0xFF26A69A),
//                   size: 30,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Saves the selected role to Firestore and then navigates.
//   Future<void> _saveRoleAndNavigate(BuildContext context) async {
//     // Get a reference to the Firestore collection
//     CollectionReference roles = FirebaseFirestore.instance.collection('user_roles');

//     try {
//       // Add a new document with a generated ID
//       await roles.add({
//         'role': _selectedRole,
//         'timestamp': FieldValue.serverTimestamp(), // Add a server timestamp
//       });
//       print('Role saved successfully to Firestore: $_selectedRole');

//       // Navigate to the next screen after saving the data
//       _navigateToNextScreen(context);
//     } catch (e) {
//       print('Error saving role to Firestore: $e');
//       // Show an error message to the user if saving fails
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save role. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _navigateToNextScreen(BuildContext context) {
//     if (_selectedRole == 'Visitor') {
//       // Navigate to the Visitor screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) =>  RequestVisitScreen()),
//       );
//     } else if (_selectedRole == 'Employee') {
//       // Navigate to the Employee screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const EmployeeScreen()),
//       );
//     } else if (_selectedRole == 'Admin') {
//       // Navigate to the Admin screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => AdminDashboard()),
//       );
//     }
//   }
// }




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms/providers/define_yourself_provider.dart';
import 'package:vms/screens/admin_dashboard.dart';
import 'package:vms/screens/request.dart';
import 'package:vms/screens/employee_screen.dart';

class DefineYourselfScreen extends StatelessWidget {
  const DefineYourselfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Define Yourself',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildRoleCard(context, 'assets/id-card.png', 'Visitor',
                        'A temporary guest accessing the workspace for a specific purpose.'),
                    const SizedBox(height: 30),
                    _buildRoleCard(context, 'assets/employee.png', 'Employee',
                        'A regular member working within the shared office space.'),
                    const SizedBox(height: 30),
                    _buildRoleCard(context, 'assets/unauthorized-person.png', 'Admin',
                        'The manager overseeing visitors and workspace operations.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: roleProvider.selectedRole != null && !roleProvider.isLoading
                    ? () async {
                        roleProvider.setLoading(true);
                        await _saveRoleAndNavigate(context, roleProvider);
                        roleProvider.setLoading(false);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: roleProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Next',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String imageUrl, String title, String description) {
    final roleProvider = Provider.of<RoleProvider>(context);
    final isSelected = roleProvider.selectedRole == title;

    return GestureDetector(
      onTap: () => roleProvider.selectRole(title),
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? const BorderSide(color: Color(0xFF26A69A), width: 3)
              : BorderSide.none,
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(imageUrl, fit: BoxFit.contain),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 8),
                    Text(description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFF26A69A), size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveRoleAndNavigate(BuildContext context, RoleProvider provider) async {
    try {
      await FirebaseFirestore.instance.collection('user_roles').add({
        'role': provider.selectedRole,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _navigateToNextScreen(context, provider.selectedRole);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving role: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _navigateToNextScreen(BuildContext context, String? role) {
    if (role == 'Visitor') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => RequestVisitScreen()));
    } else if (role == 'Employee') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeScreen()));
    } else if (role == 'Admin') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
    }
  }
}
