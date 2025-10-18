import 'package:flutter/material.dart';
import '../database/chat_database.dart';

class ChatPage extends StatefulWidget {
  final String clientId;
  final String clientName;

  const ChatPage({required this.clientId, required this.clientName, Key? key})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final data = await ChatDatabaseHelper.instance.getMessages(widget.clientId);
    setState(() => messages = data);
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final message = {
      'clientId': widget.clientId,
      'sender': 'Manager',
      'message': _controller.text.trim(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    await ChatDatabaseHelper.instance.insertMessage(message);
    _controller.clear();
    _loadMessages();
  }

  void _editMessage(int id, String currentMsg) {
    final editController = TextEditingController(text: currentMsg);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Message"),
        content: TextField(controller: editController),
        actions: [
          TextButton(
            onPressed: () async {
              await ChatDatabaseHelper.instance.updateMessage(id, editController.text);
              Navigator.pop(context);
              _loadMessages();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteMessage(int id) async {
    await ChatDatabaseHelper.instance.deleteMessage(id);
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.clientName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(msg['message']),
                  subtitle: Text(msg['timestamp']),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') _editMessage(msg['id'], msg['message']);
                      if (value == 'delete') _deleteMessage(msg['id']);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
