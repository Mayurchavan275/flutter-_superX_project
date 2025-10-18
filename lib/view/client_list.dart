import 'package:flutter/material.dart';
import 'package:manager_side/view/chatPage.dart';


class ManagerInboxPage extends StatelessWidget {
  final List<Map<String, String>> clients = [
    {"id": "1", "name": "Rohan Mehta"},
    {"id": "2", "name": "Priya Kapoor"},
    {"id": "3", "name": "Aarav Malhotra"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Client Messages")),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(client['name']!),
            trailing: const Icon(Icons.chat_bubble_outline),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    clientId: client['id']!,
                    clientName: client['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
