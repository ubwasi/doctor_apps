import 'package:flutter/material.dart';

import '../Theme/Theme.dart';

class SuccessDiolog extends StatefulWidget {
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;

  const SuccessDiolog({
    super.key,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  State<SuccessDiolog> createState() => _SuccessDiologState();
}

class _SuccessDiologState extends State<SuccessDiolog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                'Success!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: LightTheme.titleColors,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Your appointment with ${widget.doctorName} on ${widget.appointmentDate} at ${widget.appointmentTime} has been successfully booked.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: LightTheme.subTitleColors,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LightTheme.primaryColors,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
