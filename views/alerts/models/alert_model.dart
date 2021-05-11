class AlertsModel {
  final String status;
  final List<AlertModel> listAlerts;

  AlertsModel(
    this.status,
    this.listAlerts,
  );

  AlertsModel copy({
    String status,
    List<AlertModel> listAlerts,
  }) {
    return AlertsModel(
      status ?? this.status,
      listAlerts ?? this.listAlerts,
    );
  }
}

class AlertModel {
  final int id;
  final int bolusId;
  final int cowId;
  final int farmId;
  final String type;
  final String message;
  final String created;
  final String value;
  final EventModel event;
  final String farmName;
  final String hoursBack;
  final int percent;
  final List<NotificationModel> notifications;
  final FeedbackModel feedback;
  final bool opened;

  AlertModel(
    this.id,
    this.bolusId,
    this.cowId,
    this.farmId,
    this.type,
    this.message,
    this.created,
    this.value,
    this.event,
    this.farmName,
    this.hoursBack,
    this.percent,
    this.notifications,
    this.feedback,
    this.opened,
  );

  AlertModel copy({
    int id,
    int bolusId,
    int cowId,
    int farmId,
    String type,
    String message,
    String created,
    String value,
    EventModel event,
    String farmName,
    String hoursBack,
    int percent,
    List<NotificationModel> notifications,
    FeedbackModel feedback,
    bool opened,
  }) {
    return AlertModel(
      id ?? this.id,
      bolusId ?? this.bolusId,
      cowId ?? this.cowId,
      farmId ?? this.farmId,
      type ?? this.type,
      message ?? this.message,
      created ?? this.created,
      value ?? this.value,
      event ?? this.event,
      farmName ?? this.farmName,
      hoursBack ?? this.hoursBack,
      percent ?? this.percent,
      notifications ?? this.notifications,
      feedback ?? this.feedback,
      opened ?? this.opened,
    );
  }
}

class EventModel {
  final int id;
  final int objectId;
  final int farmId;
  String eventType;
  DateTime date;
  final String description;
  final String name;
  String remark;
  final String result;
  final int daysInMilk;
  String protocols;
  final List<int> alerts;

  EventModel(
    this.id,
    this.objectId,
    this.farmId,
    this.eventType,
    this.date,
    this.description,
    this.name,
    this.remark,
    this.result,
    this.daysInMilk,
    this.protocols,
    this.alerts,
  );

  EventModel copy({
    int id,
    int objectId,
    int farmId,
    String eventType,
    DateTime date,
    String description,
    String name,
    String remark,
    String result,
    int daysInMilk,
    String protocols,
    List<int> alerts,
  }) {
    return EventModel(
      id ?? this.id,
      objectId ?? this.objectId,
      farmId ?? this.farmId,
      eventType ?? this.eventType,
      date ?? this.date,
      description ?? this.description,
      name ?? this.name,
      remark ?? this.remark,
      result ?? this.result,
      daysInMilk ?? this.daysInMilk,
      protocols ?? this.protocols,
      alerts ?? this.alerts,
    );
  }

  factory EventModel.nul() {
    return EventModel(
      null,
      null,
      null,
      null,
      DateTime.now(),
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    );
  }
}

class EventFullModel {
  final int id;
  final int objectId;
  final int farmId;
  String eventType;
  DateTime date;
  final String description;
  final String name;
  String remark;
  final String result;
  final int daysInMilk;
  String protocols;
  final List<AlertModel> alerts;

  EventFullModel(
    this.id,
    this.objectId,
    this.farmId,
    this.eventType,
    this.date,
    this.description,
    this.name,
    this.remark,
    this.result,
    this.daysInMilk,
    this.protocols,
    this.alerts,
  );

  EventFullModel copy({
    int id,
    int objectId,
    int farmId,
    String eventType,
    DateTime date,
    String description,
    String name,
    String remark,
    String result,
    int daysInMilk,
    String protocols,
    List<AlertModel> alerts,
  }) {
    return EventFullModel(
      id ?? this.id,
      objectId ?? this.objectId,
      farmId ?? this.farmId,
      eventType ?? this.eventType,
      date ?? this.date,
      description ?? this.description,
      name ?? this.name,
      remark ?? this.remark,
      result ?? this.result,
      daysInMilk ?? this.daysInMilk,
      protocols ?? this.protocols,
      alerts ?? this.alerts,
    );
  }

  factory EventFullModel.nul() {
    return EventFullModel(
      null,
      null,
      null,
      null,
      DateTime.now(),
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    );
  }
}

class NotificationModel {
  final int id;
  final String receiver;
  final String created;
  final String body;
  final bool isRead;
  final bool feedback;

  NotificationModel(
    this.id,
    this.receiver,
    this.created,
    this.body,
    this.isRead,
    this.feedback,
  );

  NotificationModel copy({
    int id,
    String receiver,
    String created,
    String body,
    bool isRead,
    bool feedback,
  }) {
    return NotificationModel(
      id ?? this.id,
      receiver ?? this.receiver,
      created ?? this.created,
      body ?? this.body,
      isRead ?? this.isRead,
      feedback ?? this.feedback,
    );
  }
}

class FeedbackModel {
  final int id;
  final DateTime created;
  final bool visualSymptoms;
  double rectalTemperature;
  DateTime rectalTemperatureTime;
  final String treatmentNote;
  String generalNote;
  final bool milkDropped;
  final bool putToSort;
  final bool useful;
  final String diagnosis;

  FeedbackModel(
    this.id,
    this.created,
    this.visualSymptoms,
    this.rectalTemperature,
    this.rectalTemperatureTime,
    this.treatmentNote,
    this.generalNote,
    this.milkDropped,
    this.putToSort,
    this.useful,
    this.diagnosis,
  );

  FeedbackModel copy({
    int id,
    DateTime created,
    bool visualSymptoms,
    double rectalTemperature,
    DateTime rectalTemperatureTime,
    String treatmentNote,
    String generalNote,
    bool milkDropped,
    bool putToSort,
    bool useful,
    String diagnosis,
  }) {
    return FeedbackModel(
      id ?? this.id,
      created ?? this.created,
      visualSymptoms ?? this.visualSymptoms,
      rectalTemperature ?? this.rectalTemperature,
      rectalTemperatureTime ?? this.rectalTemperatureTime,
      treatmentNote ?? this.treatmentNote,
      generalNote ?? this.generalNote,
      milkDropped ?? this.milkDropped,
      putToSort ?? this.putToSort,
      useful ?? this.useful,
      diagnosis ?? this.diagnosis,
    );
  }

  factory FeedbackModel.nul() {
    return FeedbackModel(
      null,
      null,
      false,
      null,
      DateTime.now(),
      null,
      null,
      false,
      false,
      false,
      null,
    );
  }
}
