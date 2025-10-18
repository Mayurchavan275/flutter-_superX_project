import 'package:flutter/material.dart';
import 'package:manager_side/controller.dart/database_helper.dart';
import 'package:manager_side/view/chatPage.dart';
import 'package:manager_side/view/client360view.dart';

class ClientPortfolioPage extends StatefulWidget {
  const ClientPortfolioPage({super.key});

  @override
  State<ClientPortfolioPage> createState() => _ClientPortfolioPageState();
}

class _ClientPortfolioPageState extends State<ClientPortfolioPage> {
  List<Map<String, dynamic>> hiredClients = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    final data = await dbHelper.getClients();

    hiredClients = data;
    setState(() {});
  }

  Future<void> deleteClient(int id) async {
    await dbHelper.deleteClient(id);
    fetchClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Portfolio'),
        backgroundColor: Colors.deepPurple,
      ),
      body: hiredClients.isEmpty
          ? const Center(child: Text('No clients hired yet.'))
          : ListView.builder(
              itemCount: hiredClients.length,
              itemBuilder: (context, index) {
                final client = hiredClients[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(client['image']),
                          ),
                          title: Text(
                            client['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            "${client['skill']} • ${client['experience']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => deleteClient(client['id']),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ChatPage(
                                        clientId: 'id',
                                        clientName: 'name',
                                      );
                                    },
                                  ),
                                );
                                // Navigate to chat page (no logic change here)
                              },
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: const Text("Chat"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple.shade400,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Client360view(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.visibility),
                              label: const Text("View 360"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade400,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
