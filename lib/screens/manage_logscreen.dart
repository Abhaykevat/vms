import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms/services/firestore_service.dart';

class ManageLogscreen extends StatefulWidget {
  const ManageLogscreen({super.key});

  @override
  State<ManageLogscreen> createState() => _ManageLogscreenState();
}

class _ManageLogscreenState extends State<ManageLogscreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Manage Logs', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list_rounded), onPressed: () {}),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list_rounded, color: Colors.teal),
                label: const Text('Filter', style: TextStyle(color: Colors.teal)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[50],
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getVisits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching logs'));
                }

                final logs = snapshot.data!.docs;

                if (logs.isEmpty) {
                  return const Center(child: Text("No logs available"));
                }

                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index].data() as Map<String, dynamic>;

                    final isCheckedIn = (log['status'] ?? '').toString().toLowerCase() == "checked in";
                    final name = log['hostName'] ?? "Unknown";
                    final purpose = log['purpose'] ?? "N/A";
                    final date = log['visitDate'] ?? "";
                    final time = log['visitTime'] ?? "";
                    final location = "Skyview North Gate";
                    final visitorId = logs[index].id.substring(0, 5).toUpperCase();

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0.5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      'https://randomuser.me/api/portraits/men/1.jpg',
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: isCheckedIn ? Colors.green[50] : Colors.yellow[50],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    isCheckedIn ? Icons.check_circle : Icons.logout,
                                                    color: isCheckedIn ? Colors.green : Colors.yellow[800],
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    isCheckedIn ? 'Checked In' : 'Pending',
                                                    style: TextStyle(
                                                      color: isCheckedIn ? Colors.green : Colors.yellow[800],
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Text('1h ago', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                            const SizedBox(width: 12),
                                            Container(height: 24, width: 1.2, color: Colors.grey[300]),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 2),
                                        Text(purpose, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                                        const SizedBox(height: 2),
                                        Text('$date • $time', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                        Text(location, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Visitor ID', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(visitorId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    const SizedBox(width: 2),
                                    Icon(Icons.copy, size: 14, color: Colors.grey[400]),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 80,
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                    ),
                                    child: const Text('Details', style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
      
    );
  }
}
