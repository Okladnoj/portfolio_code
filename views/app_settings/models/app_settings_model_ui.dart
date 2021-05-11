class AppSettingModelUI {
  final String email;
  final String password;
  final List<NotificationPreferencesModelUI> notificationPreferences;
  final NotificationPeriodModelUI notificationPeriod;

  AppSettingModelUI(
    this.email,
    this.password,
    this.notificationPreferences,
    this.notificationPeriod,
  );
}

class NotificationPreferencesModelUI {
  final int id;
  final String nameEvent;
  final String setKeyEvent;
  final bool isActiveEmail;
  final bool isActiveSMS;
  final bool isActivePush;

  NotificationPreferencesModelUI(
    this.id,
    this.nameEvent,
    this.setKeyEvent,
    this.isActiveEmail,
    this.isActiveSMS,
    this.isActivePush,
  );
}

class NotificationPeriodModelUI {
  final String from;
  final String to;

  NotificationPeriodModelUI(
    this.from,
    this.to,
  );
}
