import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Launchnetic',
      theme: ThemeData.dark(),
      home: LaunchBar(),
    );
  }
}

class LaunchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: new Color(0xff333132),
      body: SafeArea(
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: Column(
              children: [
                Clock(),
                //Notifications(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 75,
              height: double.infinity,
              //color: new Color(0xff4c4a4b),
              child: AppLauncher(),
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: new Color(0xff656464),
                    ),
                  ),
                  color: new Color(0xff4c4a4b)),
            ),
          ),
        ]),
      ),
    );
  }
}

class AppLauncher extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  Future<List<Application>> _apps;

  @override
  void initState() {
    super.initState();

    _apps = DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Application>>(
      future: _apps,
      builder:
          (BuildContext content, AsyncSnapshot<List<Application>> snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              var app = snapshot.data[index];

              if (app is ApplicationWithIcon) {
                return Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: CircleAvatar(
                    backgroundImage: MemoryImage(app.icon),
                    backgroundColor: new Color(0xff4c4a4b),
                    radius: 25,
                  ),
                );
              }

              return Container();
            },
          );
        }

        return Container();
      },
    );
  }
}

class Clock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  DateTime _dateTime;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 10), (_) => _updateTime());
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }

    super.dispose();
  }

  void _updateTime() {
    setState(() => _dateTime = DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              //DateFormat('MM/dd/yyyy hh:mm:ss').format(_dateTime),
              DateFormat('HH:mm').format(_dateTime),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64),
            ),
          ),
          Text(
            DateFormat('dd/MM/yyyy').format(_dateTime),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class Notifications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  FlutterLocalNotificationsPlugin _notificationsPlugin;
  List<ActiveNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _initNotificationsPlugin();
  }

  void _initNotificationsPlugin() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);

    _loadNotifications();
  }

  void _loadNotifications() async {
    _notifications = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _notifications?.length,
      itemBuilder: (BuildContext c, int index) {
        return ListTile(
          title: Text(_notifications[index].title),
          subtitle: Text(_notifications[index].body),
        );
      },
    );
  }
}
