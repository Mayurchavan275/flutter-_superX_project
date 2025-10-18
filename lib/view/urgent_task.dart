import 'package:flutter/material.dart';
import 'package:manager_side/database/job_database.dart'; // ✅ Use same local DB
import 'package:manager_side/models/job_ticketmodel.dart';

class UrgentJobPage extends StatefulWidget {
  const UrgentJobPage({super.key});

  @override
  State<UrgentJobPage> createState() => _UrgentJobPageState();
}

class _UrgentJobPageState extends State<UrgentJobPage> {
  List<Job> urgentJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUrgentJobs();
  }

  Future<void> _loadUrgentJobs() async {
    final db = await JobDatabase.instance.database;

    // ✅ Fetch only high-priority jobs from the same local "jobs" table
    final result = await db.query(
      'jobs',
      where: 'priority = ?',
      whereArgs: ['High'],
      orderBy: 'id DESC',
    );

    setState(() {
      urgentJobs = result.map((e) => Job.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Urgent Jobs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 3,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : urgentJobs.isEmpty
              ? const Center(
                  child: Text(
                    "No High Priority Jobs Found 🚫",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUrgentJobs,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: urgentJobs.length,
                    itemBuilder: (context, index) {
                      final job = urgentJobs[index];
                      return _buildUrgentJobCard(job);
                    },
                  ),
                ),
    );
  }

  Widget _buildUrgentJobCard(Job job) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.priority_high, color: Colors.redAccent, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              job.description.isEmpty
                  ? "No Description Provided"
                  : job.description,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const Divider(height: 18, thickness: 0.6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoBadge(Icons.person_outline, job.assignedTo.isNotEmpty ? job.assignedTo : "Unassigned"),
                _infoBadge(Icons.work_outline, job.status),
                _infoBadge(Icons.calendar_today_outlined,
                    job.createdAt.split(" ").first),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.redAccent, size: 18),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
