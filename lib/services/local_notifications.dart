import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/task_models.dart';
import 'package:notes/shared/preferencias_usuario.dart';

class PushNotifications {
  static Future initializeApp() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    final prefs = PreferenciasUsuario();
    await prefs.initPrefs();

    AwesomeNotifications().initialize('resource://drawable/ic_launcher', [
      NotificationChannel(
          channelGroupKey: 'basic_tests',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.blue[700],
          ledColor: Colors.white,
          importance: NotificationImportance.High),
    ]);
  }

  static Future setNoficiations(String recordar, int number, DateTime dateTime,
      bool repeat, String details, TaskModel model) async {
    final Map<String, String> payload = {'model': jsonEncode(model)};
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: number,
            channelKey: 'basic_channel',
            body: details,
            title: recordar,
            payload: payload),
        schedule:
            NotificationCalendar.fromDate(repeats: repeat, date: dateTime));
  }
}
