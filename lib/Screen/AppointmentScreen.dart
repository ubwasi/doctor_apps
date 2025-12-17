import 'package:flutter/material.dart';
import '../Theme/Theme.dart';
import '../Widget/StatItem.dart';
import 'SuccessDiolog.dart';

class AppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const AppointmentScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  int _selectedDateIndex = -1;
  int _selectedTimeIndex = 1;
  late List<DateTime> _dates;

  final List<String> _timeSlots = [
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final days = DateTime(now.year, now.month + 1, 0).day;
    _dates = List.generate(
      days,
          (i) => firstDay.add(Duration(days: i)),
    );
    _selectedDateIndex = _dates.indexWhere(
          (d) =>
      d.year == now.year &&
          d.month == now.month &&
          d.day == now.day,
    );
  }

  String _weekday(DateTime d) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d.weekday - 1];

  String _month(DateTime d) =>
      [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ][d.month - 1];

  void _bookAppointment() {
    final date = _dates[_selectedDateIndex];
    final time = _timeSlots[_selectedTimeIndex];

    showDialog(
      context: context,
      builder: (_) => SuccessDiolog(
        doctorName: widget.doctor['name'],
        appointmentDate:
        "${_weekday(date)} ${date.day} ${_month(date)}",
        appointmentTime: time,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                doctor['image'] ??
                    "https://i.imgur.com/BoN9kdC.png",
              ),
            ),
            const SizedBox(height: 16),
            Text(
              doctor['name'],
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor['specialty']?['name'] ?? '',
              style: TextStyle(
                  color: LightTheme.subTitleColors),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: LightTheme.primaryColors,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                children: [
                  StatItem(
                      count: "${doctor['experience']}+",
                      label: "Experience"),
                  StatItem(
                      count: doctor['rating_formatted'],
                      label: "Rating"),
                  StatItem(
                      count: doctor['fees_formatted'],
                      label: "Fees"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "About Doctor",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              doctor['about'] ?? '',
              style: const TextStyle(height: 1.5),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (_, i) {
                  final selected = i == _selectedDateIndex;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedDateIndex = i),
                    child: Container(
                      width: 70,
                      margin:
                      const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? LightTheme.primaryColors
                            : Colors.white,
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text("${_dates[i].day}",
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  color: selected
                                      ? Colors.white
                                      : Colors.black)),
                          Text(_weekday(_dates[i]),
                              style: TextStyle(
                                  color: selected
                                      ? Colors.white70
                                      : Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(_timeSlots.length,
                      (i) {
                    final selected = i == _selectedTimeIndex;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedTimeIndex = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: selected
                              ? LightTheme.primaryColors
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Text(
                          _timeSlots[i],
                          style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    );
                  }),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _bookAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor:
              LightTheme.primaryColors,
            ),
            child: const Text(
              "Book Appointment",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
