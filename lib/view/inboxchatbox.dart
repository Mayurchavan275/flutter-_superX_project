import 'package:flutter/material.dart';

class UnifiedInboxPage extends StatefulWidget {
  const UnifiedInboxPage({Key? key}) : super(key: key);

  @override
  State<UnifiedInboxPage> createState() => _UnifiedInboxPageState();
}

class _UnifiedInboxPageState extends State<UnifiedInboxPage> {
  final List<Map<String, String>> chats = [
    {"name": "John Smith", "message": "Need an update on the villa maintenance", "time": "09:45 AM"},
    {"name": "Priya Mehta", "message": "Please schedule the housekeeping visit", "time": "10:30 AM"},
    {"name": "Amit Patel", "message": "Can we review my security staff list?", "time": "11:05 AM"},
    {"name": "Lisa Brown", "message": "Send invoice for gardening services", "time": "11:45 AM"},
  ];

  String selectedClient = "John Smith";
  List<Map<String, String>> messages = [
    {"sender": "Client", "text": "Hi, can you check the AC service schedule?"},
    {"sender": "Manager", "text": "Sure, I’ll check and confirm shortly."},
  ];

  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() {
    if (_msgController.text.isEmpty) return;
    setState(() {
      messages.add({"sender": "Manager", "text": _msgController.text});
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Unified Inbox", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 900;

            return isWide
                ? Row(
                    children: [
                      // LEFT PANEL - Chat List
                      Container(
                        width: constraints.maxWidth * 0.25,
                        color: Colors.white,
                        child: ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  selectedClient = chats[index]['name']!;
                                });
                              },
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text(chats[index]['name']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(chats[index]['message']!),
                              trailing: Text(chats[index]['time']!,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            );
                          },
                        ),
                      ),

                      // MAIN CHAT WINDOW
                      Expanded(
                        child: Container(
                          color: Colors.grey[50],
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey, width: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(selectedClient,
                                        style: const TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold)),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/createJobTicket');
                                      },
                                      icon: const Icon(Icons.assignment_add,
                                          color: Colors.blueAccent),
                                      tooltip: "Convert to Job Ticket",
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final msg = messages[index];
                                    final isManager = msg['sender'] == "Manager";
                                    return Align(
                                      alignment: isManager
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isManager
                                              ? Colors.blueAccent
                                              : Colors.grey[300],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          msg['text']!,
                                          style: TextStyle(
                                            color: isManager
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.attach_file,
                                            color: Colors.grey)),
                                    Expanded(
                                      child: TextField(
                                        controller: _msgController,
                                        decoration: InputDecoration(
                                          hintText: "Type a message...",
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          contentPadding:
                                              const EdgeInsets.symmetric(horizontal: 15),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _sendMessage,
                                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // RIGHT PANEL - Client Summary
                      Container(
                        width: constraints.maxWidth * 0.25,
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Client Summary",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 12),
                            const CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.person, color: Colors.white, size: 35),
                            ),
                            const SizedBox(height: 12),
                            Text("Name: $selectedClient",
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 6),
                            const Text("Contact: +91 9876543210"),
                            const Text("Last Ticket: Villa Maintenance"),
                            const Text("Priority: High",
                                style: TextStyle(color: Colors.red)),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/templates');
                              },
                              icon: const Icon(Icons.message),
                              label: const Text("Quick Templates"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : _buildMobileLayout();
          },
        ),
      ),
    );
  }

  // MOBILE VERSION
  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isManager = msg['sender'] == "Manager";
              return Align(
                alignment:
                    isManager ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isManager ? Colors.blueAccent : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    msg['text']!,
                    style: TextStyle(
                      color: isManager ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file, color: Colors.grey)),
              Expanded(
                child: TextField(
                  controller: _msgController,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
