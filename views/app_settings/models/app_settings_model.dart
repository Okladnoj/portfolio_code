class AppSettingModel {
  final String email;
  final String password;
  final List<NotificationPreferencesModel> notificationPreferences;
  final NotificationPeriodModel notificationPeriod;

  AppSettingModel(
    this.email,
    this.password,
    this.notificationPreferences,
    this.notificationPeriod,
  );

  AppSettingModel copy({
    String email,
    String password,
    List<NotificationPreferencesModel> notificationPreferences,
    NotificationPeriodModel notificationPeriod,
  }) {
    return AppSettingModel(
      email ?? this.email,
      password ?? this.password,
      notificationPreferences ?? this.notificationPreferences,
      notificationPeriod ?? this.notificationPeriod,
    );
  }

  factory AppSettingModel.empty() {
    return AppSettingModel(
      'null',
      'null',
      [
        NotificationPreferencesModel.empty(1, 'Sustain Temperature', 'setQ405Rule'),
        NotificationPreferencesModel.empty(2, 'Critical Temperature', 'setQ41Rule'),
        NotificationPreferencesModel.empty(3, 'Water Intake', 'setWI20Rule'),
        NotificationPreferencesModel.empty(4, 'Calving Prediction', 'setCIHRule'),
      ],
      NotificationPeriodModel('0', '23'),
    );
  }
}

class NotificationPreferencesModel {
  final int id;
  final String nameEvent;
  final String setKeyEvent;
  final bool isActiveEmail;
  final bool isActiveSMS;
  final bool isActivePush;

  NotificationPreferencesModel(
    this.id,
    this.nameEvent,
    this.setKeyEvent,
    this.isActiveEmail,
    this.isActiveSMS,
    this.isActivePush,
  );

  NotificationPreferencesModel copy({
    int id,
    String nameEvent,
    String setKeyEvent,
    bool isActiveEmail,
    bool isActiveSMS,
    bool isActivePush,
  }) {
    return NotificationPreferencesModel(
      id ?? this.id,
      nameEvent ?? this.nameEvent,
      setKeyEvent ?? this.setKeyEvent,
      isActiveEmail ?? this.isActiveEmail,
      isActiveSMS ?? this.isActiveSMS,
      isActivePush ?? this.isActivePush,
    );
  }

  factory NotificationPreferencesModel.empty(int id, String name, String key) {
    return NotificationPreferencesModel(
      id,
      name,
      key,
      false,
      false,
      false,
    );
  }
}

class NotificationPeriodModel {
  final String from;
  final String to;

  NotificationPeriodModel(
    this.from,
    this.to,
  );
}
