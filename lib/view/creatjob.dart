import 'package:flutter/material.dart';
import 'package:manager_side/models/job_ticketmodel.dart';
import 'package:manager_side/database/job_database.dart';
import 'package:sqflite/sqflite.dart'; // ✅ Import your local DB

class CreateEditJobTicketPage extends StatefulWidget {
  final Job? existingJob;

  const CreateEditJobTicketPage({super.key, this.existingJob});

  @override
  State<CreateEditJobTicketPage> createState() =>
      _CreateEditJobTicketPageState();
}

class _CreateEditJobTicketPageState extends State<CreateEditJobTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _assignedTo = TextEditingController();

  String _status = "New";
  String _priority = "Low"; // ✅ Added priority

  final List<String> statuses = [
    "New",
    "In Progress",
    "Awaiting Client Approval",
    "Completed"
  ];

  final List<String> priorities = [
    "Low",
    "Medium",
    "High",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingJob != null) {
      _title.text = widget.existingJob!.title;
      _description.text = widget.existingJob!.description;
      _assignedTo.text = widget.existingJob!.assignedTo;
      _status = widget.existingJob!.status;
      _priority = widget.existingJob!.priority;
    }
  }

  Future<void> _saveJob() async {
    if (_formKey.currentState!.validate()) {
      final newJob = Job(
        id: widget.existingJob?.id,
        title: _title.text.trim(),
        description: _description.text.trim(),
        status: _status,
        assignedTo: _assignedTo.text.trim(),
        createdAt: DateTime.now().toString(),
        priority: _priority,
      );

      final db = JobDatabase.instance;

      // ✅ If editing an existing job, update it
      if (widget.existingJob != null) {
        await db.updateJob(newJob);
      } else {
        await db.insertJob(newJob); // ✅ Save locally just like main job page
      }

      // ✅ If priority is High, store separately in urgent_jobs (optional)
      if (_priority == "High") {
        final urgentDb = await db.database;
        await urgentDb.insert(
          'urgent_jobs',
          newJob.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // ✅ Pop and send job back
      Navigator.pop(context, newJob);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.existingJob == null ? "Create Job" : "Edit Job Ticket"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: "Job Title"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter job title" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                items: statuses
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                decoration: const InputDecoration(labelText: "Status"),
                onChanged: (v) => setState(() => _status = v!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _assignedTo,
                decoration:
                    const InputDecoration(labelText: "Assigned To (Name)"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _priority,
                items: priorities
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                decoration: const InputDecoration(labelText: "Priority"),
                onChanged: (v) => setState(() => _priority = v!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveJob,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text("Save Job",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
