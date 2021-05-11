class AlertsModelUI {
  final String status;
  final List<AlertModelUI> listAlerts;

  AlertsModelUI(
    this.status,
    this.listAlerts,
  );
}

class AlertModelUI {
  final int id;
  final int bolusId;
  final int cowId;
  final int farmId;
  final String type;
  final String message;
  final String created;
  final String value;
  final EventModelUI event;
  final String farmName;
  final String hoursBack;
  final int percent;
  final List<NotificationModelUI> notifications;
  final FeedbackModelUI feedback;
  final bool isRead;
  final List<AlertModelUI> listAlertModelUI;

  AlertModelUI(
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
    this.isRead,
    this.listAlertModelUI,
  );
}

class EventModelUI {
  final int id;
  final int objectId;
  final int farmId;
  final String eventType;
  final String date;
  final String description;
  final String name;
  final String remark;
  final String result;
  final int daysInMilk;
  final String protocols;
  final List<int> alerts;

  EventModelUI(
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
  bool get isChoose =>
      (alerts?.first != null) ||
      (objectId != null) ||
      (eventType != null) ||
      (date != null) ||
      (remark != null) ||
      (protocols != null);
}

class EventFullModelUI {
  final int id;
  final int objectId;
  final int farmId;
  final String eventType;
  final String date;
  final String description;
  final String name;
  final String remark;
  final String result;
  final int daysInMilk;
  final String protocols;
  final List<AlertModelUI> alerts;

  EventFullModelUI(
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
  bool get isChoose =>
      (alerts?.first != null) ||
      (objectId != null) ||
      (eventType != null) ||
      (date != null) ||
      (remark != null) ||
      (protocols != null);
}

class NotificationModelUI {
  final int id;
  final String receiver;
  final String created;
  final String body;
  final bool isRead;
  final bool feedback;

  NotificationModelUI(
    this.id,
    this.receiver,
    this.created,
    this.body,
    this.isRead,
    this.feedback,
  );
}

class FeedbackModelUI {
  final int id;
  final String created;
  final bool visualSymptoms;
  final double rectalTemperature;
  final String rectalTemperatureTime;
  final String treatmentNote;
  final String generalNote;
  final bool milkDropped;
  final bool putToSort;
  final bool useful;
  final String diagnosis;

  FeedbackModelUI(
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

  bool get isChoose =>
      (visualSymptoms != null) ||
      (rectalTemperature != null) ||
      (rectalTemperatureTime != null) ||
      (milkDropped != null) ||
      (generalNote != null) ||
      (putToSort != null) ||
      (generalNote != null);
}
