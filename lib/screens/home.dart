import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm_example/main.dart';
import 'package:alarm_example/screens/edit_alarm.dart';
import 'package:alarm_example/screens/ring.dart';
import 'package:alarm_example/screens/shortcut_button.dart';
import 'package:alarm_example/widgets/tile.dart';
import 'package:alarm_example/widgets/top_row.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<AlarmSettings> alarms;

  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: AlarmEditScreen(alarmSettings: settings),
        );
      },
    );

    if (res != null && res == true) loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void deleteAlarm(AlarmSettings item) {
    Alarm.stop(item.id).then((res) {
      if (res && mounted) {
        setState(() {
          alarms.removeWhere((alarm) => alarm.id == item.id);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //int _selectedRoundUp = 1;
    return Scaffold(
      backgroundColor: const Color(0xFF2d2f41),
      appBar: AppBar(
        title: const Text(
          'Nap Alarm',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2d2f41),
      ),
      body: Column(
        children: [
          const Text('Round up to:', style: TextStyle(color: Colors.white70)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                InkWell(
                  child: topRow(size, 'Don\'t', roundUp == 1),
                  onTap: () {
                    setState(() {
                      roundUp = 1;
                    });
                  },
                ),
                InkWell(
                    child: topRow(size, '5 min', roundUp == 5),
                    onTap: () {
                      setState(() {
                        roundUp = 5;
                      });
                    }),
                InkWell(
                    child: topRow(size, '10 min', roundUp == 10),
                    onTap: () {
                      setState(() {
                        roundUp = 10;
                      });
                    }),
                InkWell(
                    child: topRow(size, '15 min', roundUp == 15),
                    onTap: () {
                      setState(() {
                        roundUp = 15;
                      });
                    }),
                InkWell(
                    child: topRow(size, '30 min', roundUp == 30),
                    onTap: () {
                      setState(() {
                        roundUp = 30;
                      });
                    }),
                InkWell(
                    child: topRow(size, '1 hr', roundUp == 60),
                    onTap: () {
                      setState(() {
                        roundUp = 60;
                      });
                    }),
              ],
            ),
          ),
          Expanded(
            child: alarms.isNotEmpty
                ? ListView.builder(
                    itemCount: alarms.length,
                    //separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return AlarmTile(
                        onDelete: () {
                          setState(() {
                            deleteAlarm(alarms[index]);
                          });
                        },
                        remainingTime:
                            alarms[index].dateTime.difference(DateTime.now()),
                        id: alarms[index].id,
                        key: Key(alarms[index].id.toString()),
                        title: TimeOfDay(
                          hour: alarms[index].dateTime.hour,
                          minute: alarms[index].dateTime.minute,
                        ).format(context),
                        onPressed: () => navigateToAlarmScreen(alarms[index]),
                        onDismissed: () {
                          Alarm.stop(alarms[index].id)
                              .then((_) => loadAlarms());
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No alarms set',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuickAddButton(refreshAlarms: loadAlarms),
            FloatingActionButton(
              onPressed: () => navigateToAlarmScreen(null),
              child: const Icon(Icons.alarm_add_rounded, size: 33),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
