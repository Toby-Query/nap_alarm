import 'dart:async';

import 'package:flutter/material.dart';

class AlarmTile extends StatefulWidget {
  const AlarmTile({
    required this.id,
    required this.title,
    required this.onPressed,
    required this.remainingTime,
    required this.onDelete,
    super.key,
    this.onDismissed,
  });

  final String title;
  final Duration remainingTime;
  final int id;
  final void Function() onPressed;
  final void Function()? onDismissed;
  final void Function() onDelete;

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  late Duration remainingTime;
  Timer? _timer;
  bool isActive = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    remainingTime = widget.remainingTime;
    startCountdown();
  }

  void startCountdown() {
    if (isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
          if (remainingTime.isNegative) {
            _timer?.cancel();
            remainingTime = Duration.zero;
          }
        });
      });
    }
  }

  void toggleAlarmState(bool value) {
    setState(() {
      isActive = value;
      if (isActive) {
        startCountdown(); // Restart countdown when reactivated
      } else {
        _timer?.cancel(); // Stop countdown when deactivated
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Dismissible(
      key: widget.key!,
      direction: widget.onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => widget.onDismissed?.call(),
      child: RawMaterialButton(
        onPressed: widget.onPressed,
        child: Container(
          //height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.red],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.02),
          margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.02,
            vertical: size.height * 0.007,
          ),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.id} mins',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  // const Icon(Icons.info, color: Colors.white, size: 30),

                  // Switch(
                  //   value: isActive,
                  //   onChanged: toggleAlarmState,
                  //   activeColor: Colors.white,
                  // ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    //'${alarms.dateTime.hour}:${alarms.dateTime.minute < 10 ? '0${alarms.dateTime.minute}' : alarms.dateTime.minute}',
                    style: const TextStyle(
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    '${remainingTime.inMinutes}m ${remainingTime.inSeconds % 60}s left',
                    //'${alarms.duration}m left',
                    style: const TextStyle(
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.delete, color: Colors.white, size: 30),
                    color: Colors.white,
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
