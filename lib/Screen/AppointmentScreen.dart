import 'package:doctor_apps/Screen/SuccessDiolog.dart';
import 'package:doctor_apps/Theme/Theme.dart';
import 'package:doctor_apps/Widget/StatItem.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  final String name;
  final String subtitle;
  final String image;

  const AppointmentScreen({
    super.key,
    required this.name,
    required this.subtitle,
    required this.image,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  int _selectedDateIndex = -1;
  int _selectedTimeIndex = 1;

  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    _dates = List.generate(
      daysInMonth,
      (index) => firstDayOfMonth.add(Duration(days: index)),
    );
    final todayIndex = _dates.indexWhere(
      (date) =>
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day,
    );
    if (todayIndex != -1) {
      _selectedDateIndex = todayIndex;
    }
  }

  final List<String> _timeSlots = [
    '11:00 AM',
    '12:00 AM',
    '01:00 AM',
    '02:00 AM',
    '03:00 AM',
    '04:00 AM',
    '05:00 AM',
    '06:00 AM',
  ];

  String _getWeekday(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  String _getMonthName(DateTime date) {
    const months = [
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
      'December',
    ];
    return months[date.month - 1];
  }

  void _handleBookAppointment() {
    if (_selectedDateIndex == -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a date.")));
      return;
    }
    final selectedDate = _dates[_selectedDateIndex];
    final appointmentDate = "${_getWeekday(selectedDate)} ${selectedDate.day} ${_getMonthName(selectedDate)}";
    final appointmentTime = _timeSlots[_selectedTimeIndex];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Appointment"),
        content: Text(
          "Booking with ${widget.name}\n"
          "Date: $appointmentDate\n"
          "Time: $appointmentTime",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the confirmation dialog
              showDialog(
                context: context,
                builder: (context) => SuccessDiolog(
                  doctorName: widget.name,
                  appointmentDate: appointmentDate,
                  appointmentTime: appointmentTime,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LightTheme.primaryColors,
            ),
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Appointment",
          style: TextStyle(
            color: LightTheme.titleColors,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(widget.image),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 5,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: LightTheme.titleColors,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            color: LightTheme.titleColors,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: LightTheme.primaryColors,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            StatItem(count: '350+', label: 'Patients'),
                            StatItem(count: '15+', label: 'Exp. years'),
                            StatItem(count: '284+', label: 'Reviews'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "About Doctor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.name} is the top most Cardiologist specialist in Nanyang Hospital at London. She is available for private consultation.",
                style: TextStyle(color: LightTheme.titleColors, height: 1.5),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Schedules",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        _getMonthName(DateTime.now()),
                        style: TextStyle(
                          color: LightTheme.subTitleColors,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: LightTheme.subTitleColors,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _dates.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedDateIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDateIndex = index;
                        });
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? LightTheme.primaryColors
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey.shade200,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: LightTheme.primaryColors.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _dates[index].day.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : LightTheme.titleColors,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getWeekday(_dates[index]),
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white70
                                    : LightTheme.subTitleColors,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 5. Visit Hour
              const Text(
                "Visit Hour",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(_timeSlots.length, (index) {
                  final isSelected = index == _selectedTimeIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTimeIndex = index;
                      });
                    },
                    child: Container(
                      width:
                          (MediaQuery.of(context).size.width - 48 - 36) /
                          4, // Calculate width for 4 cols
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? LightTheme.primaryColors
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.shade200,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: LightTheme.primaryColors.withOpacity(
                                    0.4,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          _timeSlots[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : LightTheme.subTitleColors,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // 6. Bottom Button (Floating style)
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _handleBookAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor: LightTheme.primaryColors,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Book Appointment",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
