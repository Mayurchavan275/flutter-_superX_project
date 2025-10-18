import 'package:flutter/material.dart';
import 'package:manager_side/models/job_ticketmodel.dart';
import 'package:manager_side/view/creatjob.dart';
import '../database/job_database.dart';

class JobTicketManagementPage extends StatefulWidget {
  const JobTicketManagementPage({super.key});

  @override
  State<JobTicketManagementPage> createState() =>
      _JobTicketManagementPageState();
}

class _JobTicketManagementPageState extends State<JobTicketManagementPage> {
  List<Job> _jobs = [];
  String _selectedStatus = "All";

  final List<String> statuses = [
    "All",
    "New",
    "In Progress",
    "Awaiting Client Approval",
    "Completed",
  ];

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    final jobs = await JobDatabase.instance.getAllJobs();
    setState(() => _jobs = jobs);
  }

  Future<void> _addOrEditJob({Job? job}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateEditJobTicketPage(existingJob: job),
      ),
    );

    if (result != null && result is Job) {
      if (job == null) {
        await JobDatabase.instance.insertJob(result);
      } else {
        await JobDatabase.instance.updateJob(result);
      }
      _fetchJobs();
    }
  }

  Future<void> _deleteJob(int id) async {
    await JobDatabase.instance.deleteJob(id);
    _fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    List<Job> displayedJobs = _selectedStatus == "All"
        ? _jobs
        : _jobs.where((job) => job.status == _selectedStatus).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        elevation: 6,
        centerTitle: true,
        title: const Text(
          "Job Ticket Management",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      // ---------- BODY ----------
      body: Column(
        children: [
          // 🔹 Filter & Add Button Section
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      dropdownColor: Colors.white,
                      items: statuses
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.label_outline,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(s),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: "Filter by Status",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        // prefixIcon: Icon(
                        //   Icons.filter_alt_outlined,
                        //   color: Colors.blueAccent,
                        // ),
                      ),
                      onChanged: (val) =>
                          setState(() => _selectedStatus = val ?? "All"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _addOrEditJob(),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text("Add Job"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A7BD5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Job List Section
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: displayedJobs.isEmpty
                  ? const Center(
                      child: Text(
                        "No Job Tickets Found",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: displayedJobs.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final job = displayedJobs[index];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.blue.shade50.withOpacity(0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.blueAccent.withOpacity(
                                0.1,
                              ),
                              child: const Icon(
                                Icons.work_outline,
                                color: Colors.blueAccent,
                                size: 28,
                              ),
                            ),
                            title: Text(
                              job.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Status: ${job.status}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "Assigned To: ${job.assignedTo}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "Created: ${job.createdAt}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Wrap(
                              spacing: 4,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_note_rounded,
                                    color: Colors.blueAccent,
                                    size: 28,
                                  ),
                                  onPressed: () => _addOrEditJob(job: job),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
                                    size: 28,
                                  ),
                                  onPressed: () => _deleteJob(job.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
