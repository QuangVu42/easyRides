import 'dart:async';
import 'package:flutter/material.dart';

class CountdownText extends StatefulWidget {
  final DateTime endTime;

  CountdownText({required this.endTime});

  @override
  _CountdownTextState createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  late Duration remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remaining = widget.endTime.difference(DateTime.now());

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      final diff = widget.endTime.difference(DateTime.now());
      if (diff.isNegative) {
        t.cancel();
      }
      setState(() {
        remaining = diff;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    if (d.isNegative) return "Hết hạn";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(d.inHours.remainder(24));
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    if (d.inDays > 0) {
      return "${d.inDays} ngày $hours:$minutes:$seconds";
    }
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Hạn ra giá: ${_format(remaining)}",
      style: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
