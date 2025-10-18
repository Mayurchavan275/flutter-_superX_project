import 'package:flutter/material.dart';
import 'package:manager_side/controller.dart/database_helper.dart';
import 'package:manager_side/view/client360view.dart';
import 'package:manager_side/view/clientPortfolio.dart';

class ClientHiringPage extends StatefulWidget {
  const ClientHiringPage({super.key});

  @override
  State<ClientHiringPage> createState() => _ClientHiringPageState();
}

class _ClientHiringPageState extends State<ClientHiringPage> {
  List<Map<String, dynamic>> clients = [
    {
      'name': 'Rahul Sharma',
      'skill': 'UI/UX Designer',
      'experience': '3 years',
      'image': 'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
    },
    {
      'name': 'Priya Mehta',
      'skill': 'Flutter Developer',
      'experience': '2 years',
      'image': 'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
    },
    {
      'name': 'Amit Verma',
      'skill': 'Backend Engineer',
      'experience': '5 years',
      'image': 'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
    },
    {
      'name': 'Sneha Patel',
      'skill': 'Data Analyst',
      'experience': '4 years',
      'image': 'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
    },
  ];

  final dbHelper = DatabaseHelper.instance;

  Future<void> hireClient(Map<String, dynamic> client) async {
    await dbHelper.insertClient(client);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${client['name']} hired successfully!")),
    );
  }

  void openPortfolio() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ClientPortfolioPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Hiring Page'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: const Icon(Icons.people), onPressed: openPortfolio),
        ],
      ),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          return GestureDetector(
            onDoubleTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Client360view();
                  },
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(client['image']),
                  radius: 30,
                ),
                title: Text(
                  client['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "${client['skill']} • ${client['experience']}",
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: ElevatedButton(
                  onPressed: () => hireClient(client),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text(
                    'Hire',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
