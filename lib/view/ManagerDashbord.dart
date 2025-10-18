import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_side/view/clientPortfolio.dart';
import 'package:manager_side/view/client_HiringPage.dart';
import 'package:manager_side/view/client_list.dart';
import 'package:manager_side/view/creatjob.dart';
import 'package:manager_side/view/inboxchatbox.dart';
import 'package:manager_side/view/jobticketmangement.dart';
import 'package:manager_side/view/manager_profile.dart';
import 'package:manager_side/view/manager_schedules.dart';
import 'package:manager_side/view/provider_dispatch_page%20.dart';
import 'package:manager_side/view/urgent_task.dart';

class ManagerDashboardPage extends StatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  State<ManagerDashboardPage> createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends State<ManagerDashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String todayDate = DateFormat(
      'EEEE, MMM d, yyyy',
    ).format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Hero(
              tag: "managerAvatar",
              child: const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000'),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Welcome, Manager",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 25,
              color: Colors.deepPurple,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManagerProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ManagerSchedules();
                  },
                ),
              );
            },
          ),

          // 🌟 NEW: Manager Profile Icon
          const SizedBox(width: 10),
        ],
      ),

      // Main Body
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard Overview",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(todayDate, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              _buildQuickActions(context),
              const SizedBox(height: 30),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _animatedInfoCard(
                    Icons.message,
                    "New Messages",
                    "5 unread messages",
                    Colors.blueAccent,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ManagerInboxPage();
                          },
                        ),
                      );
                    },
                  ),
                  _animatedInfoCard(
                    Icons.warning_amber_rounded,
                    "Urgent Tasks",
                    "3 tasks need attention",
                    Colors.redAccent,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return UrgentJobPage();
                          },
                        ),
                      );
                    },
                  ),
                  _animatedInfoCard(
                    Icons.calendar_today,
                    "Today’s Schedule",
                    "2 appointments today",
                    Colors.green,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ManagerSchedules();
                          },
                        ),
                      );// 
                    },
                  ),

                  _animatedInfoCard(
                    Icons.people,
                    "Active Cli;nts",
                    "12 assigned clients",
                    Colors.orangeAccent,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientPortfolioPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text(
                "Tasks Requiring Immediate Attention",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildTaskList(),
              const SizedBox(height: 30),

              Text(
                "Today’s Appointments",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildScheduleList(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ QUICK ACTIONS ------------------
  Widget _buildQuickActions(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return CreateEditJobTicketPage();
                  },
                ),
              );
            },

            child: _quickActionCard(
              Icons.add_circle,
              "Create Job",
              Colors.blue,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return MyClientPortfolioPage();
          //         },
          //       ),
          //     );
          //   },
          //   child: _quickActionCard(
          //     Icons.person_add,
          //     "MY ClientS",
          //     Colors.green,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return JobTicketManagementPage();
                  },
                ),
              );
            },
            child: _quickActionCard(
              Icons.assignment,
              "View Tasks",
              Colors.orange,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ClientHiringPage();
                  },
                ),
              );
            },
            child: _quickActionCard(
              Icons.supervised_user_circle,
              "Client Profiles",
              Colors.purple,
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProviderDispatchPage(),
                ),
              );
            },
            child: _quickActionCard(
              Icons.local_shipping,
              "Dispatch Provider",
              Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionCard(IconData icon, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // ------------------ INFO CARD ------------------
  Widget _animatedInfoCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback? onTap,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap, // ✅ now navigation works here
        borderRadius: BorderRadius.circular(18),
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ TASK LIST ------------------
  Widget _buildTaskList() {
    final tasks = [
      {"title": "Approve Client Job Ticket", "priority": "High"},
      {"title": "Update Provider Assignment", "priority": "Medium"},
      {"title": "Check Payment Status", "priority": "High"},
    ];

    return Column(
      children: tasks
          .map(
            (task) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.task_alt, color: Colors.redAccent),
                title: Text(
                  task["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Priority: ${task["priority"]!}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  // ------------------ SCHEDULE ------------------
  Widget _buildScheduleList() {
    final schedule = [
      {"time": "10:00 AM", "event": "Client Meeting - Mr. Sharma"},
      {"time": "1:00 PM", "event": "Staff Review - Elderly Care Team"},
    ];

    return Column(
      children: schedule
          .map(
            (item) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.green),
                title: Text(
                  item["event"]!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Time: ${item["time"]!}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ------------------ CLIENT PROFILE PAGE ------------------
class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Profile"),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          "Client Profile & Hiring Section",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}

// ------------------ MANAGER PROFILE PAGE ------------------
