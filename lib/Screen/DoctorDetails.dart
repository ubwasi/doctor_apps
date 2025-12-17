import 'package:doctor_apps/domain/requests/doctor_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Theme/Theme.dart';

class DoctorDetails extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetails({Key? key, required this.doctor}) : super(key: key);

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  Map<String, dynamic>? _doctorDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    final result = await getDoctorDetails(widget.doctor['id']);
    if (mounted) {
      if (result['success']) {
        setState(() {
          _doctorDetails = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to load details.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor['name'] ?? 'Doctor Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _doctorDetails == null
              ? Center(child: Text('Failed to load details.'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 24),
                      _buildInfoCards(context),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(context, 'About'),
                            const SizedBox(height: 8),
                            Text(
                              _doctorDetails!['about'] ?? 'No information available.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700], height: 1.5),
                            ),
                            const SizedBox(height: 24),
                            _buildSectionTitle(context, 'Working Schedule'),
                            const SizedBox(height: 8),
                            _buildSchedule(context),
                            const SizedBox(height: 24),
                            _buildSectionTitle(context, 'Hospital Information'),
                            const SizedBox(height: 8),
                            _buildHospitalInfo(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: _doctorDetails == null ? null : _buildBookAppointmentButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              _doctorDetails!['image'] ?? 'https://i.imgur.com/BoN9kdC.png',
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                Image.network('https://i.imgur.com/BoN9kdC.png', height: 120, width: 120, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _doctorDetails!['name'] ?? 'N/A',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _doctorDetails!['specialty']?['name'] ?? 'N/A',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: LightTheme.primaryColors),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${_doctorDetails!['rating_formatted']} (${_doctorDetails!['total_reviews']} reviews)',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoCard(context, 'Experience', _doctorDetails!['experience_text'] ?? 'N/A', Icons.medical_services_outlined),
          _infoCard(context, 'Fees', _doctorDetails!['fees_formatted'] ?? 'N/A', Icons.monetization_on_outlined),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: LightTheme.primaryColors, size: 30),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSchedule(BuildContext context) {
    final schedules = _doctorDetails!['schedules'] as List? ?? [];

    if (schedules.isEmpty) {
      return const Text('No schedule found.');
    }

    return Column(
      children: schedules.map((schedule) {
        final startTimeString = schedule['start_time'] as String?;
        final endTimeString = schedule['end_time'] as String?;
        final startTime = startTimeString != null ? DateFormat.jm().format(DateFormat('HH:mm:ss').parse(startTimeString)) : 'N/A';
        final endTime = endTimeString != null ? DateFormat.jm().format(DateFormat('HH:mm:ss').parse(endTimeString)) : 'N/A';
        final isActive = schedule['is_active'] as bool? ?? false;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: isActive ? Colors.white : Colors.grey[200],
          child: ListTile(
            leading: Icon(Icons.calendar_today_outlined, color: isActive ? LightTheme.primaryColors : Colors.grey),
            title: Text(schedule['day_name'], style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey)),
            subtitle: Text('$startTime - $endTime', style: TextStyle(color: isActive ? Colors.black54 : Colors.grey)),
            trailing: isActive ? const Icon(Icons.keyboard_arrow_right) : null,
            onTap: isActive ? () {} : null,
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildHospitalInfo(BuildContext context) {
      final hospital = _doctorDetails!['hospital'] as Map<String, dynamic>?;
      if (hospital == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(context, Icons.local_hospital_outlined, hospital['name'] ?? 'N/A'),
          const SizedBox(height: 8),
          _infoRow(context, Icons.location_on_outlined, '${hospital['address']}, ${hospital['city']}'),
        ],
      );
  }

  Widget _infoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
      ],
    );
  }

  Widget _buildBookAppointmentButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: LightTheme.primaryColors,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking functionality not implemented yet.')),
          );
        },
        child: const Text(
          'Book Appointment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
