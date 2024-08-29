import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:alarm_example/main.dart';
import 'package:flutter/material.dart';

class AlarmEditScreen extends StatefulWidget {
  const AlarmEditScreen({super.key, this.alarmSettings});

  final AlarmSettings? alarmSettings;

  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  //Timer? countdownTimer;
  bool loading = false;
  late bool creating;
  late DateTime selectedDateTime;
  //late Duration remainingTime = Duration.zero;
  //late bool loopAudio = true;
  //late bool vibrate = true;
  //late double? volume;
  late String assetAudio;
  late int minutes = 1;
  late int timeId = 0;

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      // loopAudio = true;
      // vibrate = true;
      // volume = null;
      assetAudio = 'assets/marimba.mp3';
      minutes = 1;
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
      // loopAudio = widget.alarmSettings!.loopAudio;
      // vibrate = widget.alarmSettings!.vibrate;
      // volume = widget.alarmSettings!.volume;
      assetAudio = widget.alarmSettings!.assetAudioPath;
      minutes = selectedDateTime.difference(DateTime.now()).inMinutes;
      timeId = minutes;
    }

    // calculateRemainingTime();
    // startCountdown();
  }

  // void calculateRemainingTime() {
  //   final now = DateTime.now();
  //   remainingTime = selectedDateTime.difference(now);
  // }
  //
  // void startCountdown() {
  //   countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       calculateRemainingTime();
  //       if (remainingTime.isNegative) {
  //         countdownTimer?.cancel();
  //       }
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   countdownTimer?.cancel();
  //   super.dispose();
  // }

  // String getDay() {
  //   final now = DateTime.now();
  //   final today = DateTime(now.year, now.month, now.day);
  //   final difference = selectedDateTime.difference(today).inDays;
  //
  //   switch (difference) {
  //     case 0:
  //       return 'Today';
  //     case 1:
  //       return 'Tomorrow';
  //     case 2:
  //       return 'After tomorrow';
  //     default:
  //       return 'In $difference days';
  //   }
  // }

  // Future<void> pickTime() async {
  //   final res = await showTimePicker(
  //     initialTime: TimeOfDay.fromDateTime(selectedDateTime),
  //     context: context,
  //   );
  //
  //   if (res != null) {
  //     setState(() {
  //       final now = DateTime.now();
  //       selectedDateTime = now.copyWith(
  //         hour: res.hour,
  //         minute: res.minute,
  //         second: 0,
  //         millisecond: 0,
  //         microsecond: 0,
  //       );
  //       if (selectedDateTime.isBefore(now)) {
  //         selectedDateTime = selectedDateTime.add(const Duration(days: 1));
  //       }
  //     });
  //   }
  // }

  void calculateAlarmTime() {
    final now = DateTime.now();
    //minutes = calculateRoundedTime(minutes, roundUp);
    selectedDateTime = calculateRoundedTime(minutes, roundUp).copyWith(
      second: 0,
      millisecond: 0,
    );
  }

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

  AlarmSettings buildAlarmSettings() {
    final id = minutes;
    calculateAlarmTime();

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      assetAudioPath: assetAudio,
      notificationTitle: 'Alarm example',
      notificationBody: 'Your alarm ($id mins) is ringing',
      enableNotificationOnKill: Platform.isIOS,
      volume: 0.8,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res && mounted) Navigator.pop(context, true);
      setState(() => loading = false);
    });
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res && mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: saveAlarm,
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(
                        'Save',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.blueAccent),
                      ),
              ),
            ],
          ),
          // Text(
          //   getDay(),
          //   style: Theme.of(context)
          //       .textTheme
          //       .titleMedium!
          //       .copyWith(color: Colors.blueAccent.withOpacity(0.8)),
          // ),
          // RawMaterialButton(
          //   onPressed: pickTime,
          //   fillColor: Colors.grey[200],
          //   child: Container(
          //     margin: const EdgeInsets.all(20),
          //     child: Text(
          //       TimeOfDay.fromDateTime(selectedDateTime).format(context),
          //       style: Theme.of(context)
          //           .textTheme
          //           .displayMedium!
          //           .copyWith(color: Colors.blueAccent),
          //     ),
          //   ),
          // ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Minutes from now'),
            onChanged: (value) {
              final parsedValue = int.tryParse(value);
              if (parsedValue != null && parsedValue > 0) {
                setState(() => minutes = parsedValue);
              }
            },
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Loop alarm audio',
          //       style: Theme.of(context).textTheme.titleMedium,
          //     ),
          //     Switch(
          //       value: loopAudio,
          //       onChanged: (value) => setState(() => loopAudio = value),
          //     ),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Vibrate',
          //       style: Theme.of(context).textTheme.titleMedium,
          //     ),
          //     Switch(
          //       value: vibrate,
          //       onChanged: (value) => setState(() => vibrate = value),
          //     ),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sound',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: assetAudio,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'assets/marimba.mp3',
                    child: Text('Marimba'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/nokia.mp3',
                    child: Text('Nokia'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/mozart.mp3',
                    child: Text('Mozart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/star_wars.mp3',
                    child: Text('Star Wars'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/one_piece.mp3',
                    child: Text('One Piece'),
                  ),
                ],
                onChanged: (value) => setState(() => assetAudio = value!),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Custom volume',
          //       style: Theme.of(context).textTheme.titleMedium,
          //     ),
          //     Switch(
          //       value: volume != null,
          //       onChanged: (value) =>
          //           setState(() => volume = value ? 0.5 : null),
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 30,
          //   child: volume != null
          //       ? Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Icon(
          //               volume! > 0.7
          //                   ? Icons.volume_up_rounded
          //                   : volume! > 0.1
          //                       ? Icons.volume_down_rounded
          //                       : Icons.volume_mute_rounded,
          //             ),
          //             Expanded(
          //               child: Slider(
          //                 value: volume!,
          //                 onChanged: (value) {
          //                   setState(() => volume = value);
          //                 },
          //               ),
          //             ),
          //           ],
          //         )
          //       : const SizedBox(),
          // ),
          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'Delete Alarm',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}
