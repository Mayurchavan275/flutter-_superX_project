import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ProviderDispatchPage extends StatefulWidget {
  const ProviderDispatchPage({super.key});

  @override
  State<ProviderDispatchPage> createState() => _ProviderDispatchPageState();
}

class _ProviderDispatchPageState extends State<ProviderDispatchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;

  late GoogleMapController _mapController;
  final List<Map<String, dynamic>> _providers = [
    {
      "name": "Rahul Sharma",
      "skill": "Electrician",
      "rating": 4.8,
      "jobs": 2,
      "status": "Available"
    },
    {
      "name": "Arun Mehta",
      "skill": "Plumber",
      "rating": 4.6,
      "jobs": 1,
      "status": "On Job"
    },
    {
      "name": "Rohit Patel",
      "skill": "Gardener",
      "rating": 4.9,
      "jobs": 0,
      "status": "Available"
    },
  ];

  final Map<String, dynamic> _jobSummary = {
    "title": "Fix Power Issue in Apartment 201",
    "client": "Mr. Sharma",
    "budget": "₹1200",
    "priority": "High"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Provider Dispatch & Scheduling",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- JOB SUMMARY --------
            _buildJobSummaryCard(),

            const SizedBox(height: 16),

            // -------- SEARCH PANEL --------
            _buildSearchFilters(),

            const SizedBox(height: 16),

            // -------- MAP VIEW --------
            _buildMapView(),

            const SizedBox(height: 16),

            // -------- PROVIDER LIST --------
            Text("Available Providers",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            _buildProviderList(),
          ],
        ),
      ),
    );
  }

  // ---------------- JOB SUMMARY ----------------
  Widget _buildJobSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.blueAccent.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.work, color: Colors.blueAccent, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_jobSummary["title"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Client: ${_jobSummary['client']}"),
                  Text("Budget: ${_jobSummary['budget']}"),
                  Text("Priority: ${_jobSummary['priority']}",
                      style: const TextStyle(color: Colors.redAccent)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- FILTER PANEL ----------------
  Widget _buildSearchFilters() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      controller: _skillController,
                      icon: Icons.build,
                      label: "Skill (e.g., Electrician)"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                      controller: _locationController,
                      icon: Icons.location_on,
                      label: "Location"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2026),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    icon: const Icon(Icons.date_range),
                    label: Text(_selectedDate == null
                        ? "Select Date"
                        : DateFormat('dd MMM yyyy').format(_selectedDate!)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required IconData icon,
      required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  // ---------------- MAP VIEW ----------------
  Widget _buildMapView() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          onMapCreated: (controller) => _mapController = controller,
          initialCameraPosition: const CameraPosition(
            target: LatLng(19.0760, 72.8777), // Mumbai
            zoom: 12,
          ),
          markers: {
            const Marker(
              markerId: MarkerId("p1"),
              position: LatLng(19.0760, 72.8777),
              infoWindow: InfoWindow(title: "Rahul Sharma"),
            ),
            const Marker(
              markerId: MarkerId("p2"),
              position: LatLng(19.0820, 72.8900),
              infoWindow: InfoWindow(title: "Arun Mehta"),
            ),
          },
        ),
      ),
    );
  }

  // ---------------- PROVIDER LIST ----------------
  Widget _buildProviderList() {
    return Column(
      children: _providers.map((provider) {
        Color statusColor =
            provider["status"] == "Available" ? Colors.green : Colors.orange;
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              child: const Icon(Icons.person, color: Colors.blueAccent),
            ),
            title: Text(provider["name"],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${provider["skill"]} • ⭐ ${provider["rating"]}"),
                Text("Active Jobs: ${provider["jobs"]}"),
                Text("Status: ${provider["status"]}",
                    style: TextStyle(color: statusColor)),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text("${provider["name"]} assigned successfully!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Assign"),
            ),
          ),
        );
      }).toList(),
    );
  }
}
