import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmRingScreen extends StatelessWidget {
  const AlarmRingScreen({required this.alarmSettings, super.key});

  final AlarmSettings alarmSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2d2f41),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'You alarm (${alarmSettings.id} mins) is ringing...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        final now = DateTime.now();
                        Alarm.set(
                          alarmSettings: alarmSettings.copyWith(
                            dateTime: DateTime(
                              now.year,
                              now.month,
                              now.day,
                              now.hour,
                              now.minute,
                            ).add(const Duration(minutes: 5)),
                          ),
                        ).then((_) {
                          if (context.mounted) Navigator.pop(context);
                        });
                      },
                      child: const Text(
                        '+5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        final now = DateTime.now();
                        Alarm.set(
                          alarmSettings: alarmSettings.copyWith(
                            dateTime: DateTime(
                              now.year,
                              now.month,
                              now.day,
                              now.hour,
                              now.minute,
                            ).add(const Duration(minutes: 10)),
                          ),
                        ).then((_) {
                          if (context.mounted) Navigator.pop(context);
                        });
                      },
                      child: const Text(
                        '+10',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        final now = DateTime.now();
                        Alarm.set(
                          alarmSettings: alarmSettings.copyWith(
                            dateTime: DateTime(
                              now.year,
                              now.month,
                              now.day,
                              now.hour,
                              now.minute,
                            ).add(const Duration(minutes: 15)),
                          ),
                        ).then((_) {
                          if (context.mounted) Navigator.pop(context);
                        });
                      },
                      child: const Text(
                        '+15',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        final now = DateTime.now();
                        Alarm.set(
                          alarmSettings: alarmSettings.copyWith(
                            dateTime: DateTime(
                              now.year,
                              now.month,
                              now.day,
                              now.hour,
                              now.minute,
                            ).add(const Duration(minutes: 30)),
                          ),
                        ).then((_) {
                          if (context.mounted) Navigator.pop(context);
                        });
                      },
                      child: const Text(
                        '+30',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                RawMaterialButton(
                  onPressed: () {
                    Alarm.stop(alarmSettings.id).then((_) {
                      if (context.mounted) Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Stop',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
