import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vms/services/firestore_service.dart';

class AdminDashboard extends StatelessWidget {
  final Color primaryGreen = Color(0xFF0F9D58);
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          
            Row(
              children: [
                CircleAvatar(radius: 24, backgroundImage: AssetImage('assets/employee.png')),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Good Morning Nikhil!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Genpact, 17th Floor", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                Spacer(),
                Icon(Icons.notifications),
              ],
            ),
            SizedBox(height: 24),

            /// Heads Up
            SectionHeader(title: "Heads Up"),
            SizedBox(height: 8),
            Row(
              children: const [
                Expanded(
                  child: InfoCard(
                    title: "Visit Request",
                    name: "Pavan Kalyan",
                    detail: "Client visit",
                    time: "26th Aug - 10:30AM to 12:30PM",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: InfoCard(
                    title: "Reschedule Request",
                    name: "Akhilesh",
                    detail: "reschedule the meeting",
                    time: "",
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            /// Quick Action
            SectionHeader(title: "Quick Action"),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                QuickAction(icon: Icons.send, label: "Send Invite"),
                QuickAction(icon: Icons.manage_history, label: "Manage Requests"),
                QuickAction(icon: Icons.playlist_add_check, label: "Ongoing Visits"),
                QuickAction(icon: Icons.calendar_today, label: "My Calendar"),
              ],
            ),
            SizedBox(height: 24),

            /// Upcoming Visits (Live from Firestore)
            SectionHeader(title: "Upcoming"),
            SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getVisits(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.docs;

                if (data.isEmpty) {
                  return Center(child: Text("No upcoming visits"));
                }

                return Column(
                  children: data.map((doc) {
                    final visit = doc.data() as Map<String, dynamic>;
                    final docId = doc.id;

                    return Column(
                      children: [
                        UpcomingCard(
                          status: visit['status'] ?? "Pending",
                          name: "${visit['company']} is visiting",
                          purpose: visit['purpose'] ?? "N/A",
                          floor: "Skyview, 17th Floor",
                          time: "${visit['visitDate']} - ${visit['visitTime']}",
                          minutesAgo: "Just now",
                          avatar: 'assets/avatar.png',
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatusButton(docId: docId, label: "Check-in", color: Colors.green),
                            StatusButton(docId: docId, label: "No-show", color: Colors.orange),
                            StatusButton(docId: docId, label: "Cancelled", color: Colors.red),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Spacer(),
        Text("See All", style: TextStyle(color: Colors.green)),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title, name, detail, time;
  const InfoCard({
    required this.title,
    required this.name,
    required this.detail,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 170),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: Colors.grey, fontSize: 12)),
        SizedBox(height: 4),
        Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Purpose: $detail", style: TextStyle(fontSize: 12, color: Colors.black54)),
        if (time.isNotEmpty)
          Text(time, style: TextStyle(fontSize: 12, color: Colors.black54)),
        SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff33CC99),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {},
          child: Text("View Details", style: TextStyle(color: Colors.white)),
        ),
      ]),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const QuickAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.all(12),
        child: Icon(icon, color: Colors.black),
      ),
      SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 12)),
    ]);
  }
}

class UpcomingCard extends StatelessWidget {
  final String status, name, purpose, floor, time, minutesAgo, avatar;
  const UpcomingCard({
    required this.status,
    required this.name,
    required this.purpose,
    required this.floor,
    required this.time,
    required this.minutesAgo,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(status, style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(minutesAgo, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          SizedBox(height: 8),
          Divider(thickness: 1, color: Colors.grey.shade200),
          SizedBox(height: 8),

          /// Info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/profile1.jpg",
                  width: 50,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 2),
                    Text(purpose, style: TextStyle(fontSize: 12, color: Colors.black54)),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            floor,
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              time,
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        Text(
                          "View Details",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusButton extends StatelessWidget {
  final String docId;
  final String label;
  final Color color;

  const StatusButton({
    required this.docId,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        try {
          await _firestoreService.updateVisitStatus(docId, label);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Status updated to '$label'")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error updating status"), backgroundColor: Colors.red),
          );
        }
      },
      child: Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}
