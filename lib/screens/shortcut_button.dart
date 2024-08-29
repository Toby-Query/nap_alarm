import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class QuickAddButton extends StatefulWidget {
  const QuickAddButton({
    required this.refreshAlarms,
    super.key,
  });

  final void Function() refreshAlarms;

  @override
  State<QuickAddButton> createState() => _QuickAddButtonState();
}

class _QuickAddButtonState extends State<QuickAddButton> {
  bool showMenu = false;

  DateTime calculateRoundedTime(int duration, int roundUpToMinutes) {
    DateTime now = DateTime.now();
    DateTime alarmTime = now.add(Duration(minutes: duration));

    if (roundUpToMinutes > 0) {
      int minutes = alarmTime.minute;
      int remainder = minutes % roundUpToMinutes;
      if (remainder != 0) {
        int adjustment = roundUpToMinutes - remainder;
        alarmTime = alarmTime.add(Duration(minutes: adjustment));
      }
    }

    return alarmTime;
  }

  Future<void> onPressButton(int minutes) async {
    var dateTime = calculateRoundedTime(minutes, roundUp);
    double? volume;

    if (minutes != 0) {
      dateTime = dateTime.copyWith(second: 0, millisecond: 0);
      volume = 0.5;
    }

    setState(() => showMenu = false);

    final alarmSettings = AlarmSettings(
      id: minutes,
      dateTime: dateTime,
      assetAudioPath: 'assets/marimba.mp3',
      volume: 0.8,
      notificationTitle: 'Alarm example',
      notificationBody: 'Shortcut button alarm with delay of $minutes minutes',
      enableNotificationOnKill: Platform.isIOS,
    );

    await Alarm.set(alarmSettings: alarmSettings);

    widget.refreshAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () => onPressButton(30),
            backgroundColor: Colors.red,
            heroTag: null,
            child: const Text('+30m', textAlign: TextAlign.center),
          ),
          FloatingActionButton(
            onPressed: () => onPressButton(60),
            backgroundColor: Colors.red,
            heroTag: null,
            child: const Text('+1hr', textAlign: TextAlign.center),
          ),
          FloatingActionButton(
            onPressed: () => onPressButton(120),
            backgroundColor: Colors.red,
            heroTag: null,
            child: const Text('+2hr', textAlign: TextAlign.center),
          ),
          FloatingActionButton(
            onPressed: () => onPressButton(240),
            backgroundColor: Colors.red,
            heroTag: null,
            child: const Text('+4hr', textAlign: TextAlign.center),
          ),
          // TextButton(
          //   onPressed: () => onPressButton(24),
          //   child: const Text('+24h'),
          // ),
          // TextButton(
          //   onPressed: () => onPressButton(36),
          //   child: const Text('+36h'),
          // ),
          // TextButton(
          //   onPressed: () => onPressButton(48),
          //   child: const Text('+48h'),
          // ),
        ],
      ),
    );
  }
}
