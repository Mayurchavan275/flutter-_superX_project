import 'package:flutter/material.dart';
import 'package:manager_side/view/chatPage.dart';

class Client360view extends StatefulWidget {
  const Client360view({super.key});

  @override
  State<Client360view> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<Client360view> {
  late Map<String, dynamic> client;

  @override
  void initState() {
    super.initState();

    // 🔹 Default Client Data (you can later replace this with actual database/Firebase data)
    client = {
      "id": "1",
      "name": "Mr. Rohan Mehta",
      "email": "rohan.mehta@gmail.com",
      "phone": "+91 9876543210",
      "image": "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000", // Make sure this image exists in assets
      "lastInteraction": "2 days ago",
    };
  }

  // 🔹 Section Title
  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 26),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Header Section
  Widget buildClientHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            
            radius: 50,
            backgroundImage: NetworkImage(client["image"]),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client["name"] ?? "Unknown Client",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.white70, size: 16),
                    const SizedBox(width: 3),
                    Text(client["email"] ?? "",
                        style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.white70, size: 16),
                    const SizedBox(width: 5),
                    Text(client["phone"] ?? "",
                        style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Last Interaction: ${client["lastInteraction"] ?? "N/A"}",
                  style: const TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic, fontSize: 13),
                ),
              ],
            ),
          ),
          SizedBox(width: 5,),
          IconButton(
            icon: const Icon(Icons.message_rounded, color: Colors.white, size: 32),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    clientId: client["id"] ?? "1",
                    clientName: client["name"] ?? "Client",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 🔹 Property Section
  Widget buildPropertiesSection() {
    final properties = [
      "Luxury Villa - Pune",
      "High-Rise Apartment - Mumbai",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Properties", Icons.home_work_rounded),
        ...properties.map((p) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.home, color: Colors.teal, size: 32),
              title: Text(p,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              subtitle: const Text("Managed Property"),
            ),
          );
        }).toList(),
      ],
    );
  }

  // 🔹 Staff Section
  Widget buildStaffSection() {
    final staff = [
      {"name": "Ramesh Kumar", "role": "Maintenance Supervisor"},
      {"name": "Anita Sharma", "role": "Interior Designer"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Active Staff", Icons.people_alt_rounded),
        ...staff.map((s) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: const Icon(Icons.person_pin_circle,
                  color: Colors.orangeAccent, size: 30),
              title: Text(s["name"]!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              subtitle: Text(s["role"]!,
                  style: const TextStyle(color: Colors.black54, fontSize: 14)),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
          );
        }).toList(),
      ],
    );
  }

  // 🔹 Requests Section
  Widget buildRequestsSection() {
    final requests = [
      {"title": "Lighting Fix", "status": "Completed"},
      {"title": "Pool Cleaning", "status": "In Progress"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Recent Requests", Icons.assignment_rounded),
        ...requests.map((r) {
          Color statusColor;
          IconData statusIcon;

          switch (r["status"]) {
            case "Completed":
              statusColor = Colors.green;
              statusIcon = Icons.check_circle;
              break;
            case "In Progress":
              statusColor = Colors.orange;
              statusIcon = Icons.timelapse;
              break;
            default:
              statusColor = Colors.grey;
              statusIcon = Icons.pending;
          }

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.assignment, color: Colors.blueAccent, size: 30),
              title: Text(r["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              subtitle: Text("Status: ${r["status"]}",
                  style: const TextStyle(fontSize: 14)),
              trailing: Icon(statusIcon, color: statusColor),
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        title: Text("${client["name"]}'s Profile",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF5B86E5),
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildClientHeader(),
            buildPropertiesSection(),
            buildStaffSection(),
            buildRequestsSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
