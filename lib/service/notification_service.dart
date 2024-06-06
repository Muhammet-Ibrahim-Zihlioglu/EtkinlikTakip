import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:etkinlik_takip_projesi/main.dart';
import 'package:etkinlik_takip_projesi/screen/Notifications/awesomeNotification.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: "high_importance_channel",
          channelKey: "high_importance_channel",
          channelName: "Basic Notifications",
          channelDescription: "Notification channel for basic tests",
          importance: NotificationImportance.High,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: "high_importance_channel",
          channelGroupName: 'Group 1',
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint("onNotificationCreatedMethod");
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint("onDismissActionReceivedMethod");
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint("onNotificationDisplayedMethod");
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint("onActionReceivedMethod");
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => AwesomeNotificationsPage(),
      ));
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
    final DateTime? scheduleDate,
  }) async {
    assert(!scheduled || (scheduled && scheduleDate != null));
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1, // -1 olarak bırakmak, otomatik ID oluşturur.
        channelKey: "high_importance_channel",
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationCalendar.fromDate(
              date: scheduleDate!,
              preciseAlarm: true,
            )
          : null,
    );
  }

  static Future<void> scheduleAlarmNotification({
    required final String title,
    required final String body,
    required final DateTime dateTime,
  }) async {
    await showNotification(
      title: title,
      body: body,
      scheduled: true,
      scheduleDate: dateTime,
    );
  }
}
