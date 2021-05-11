class AlertsModelRepository {
  final String status;
  final List<AlertModelRepository> data;

  AlertsModelRepository(
    this.status,
    this.data,
  );

  AlertsModelRepository.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        data = _safeToListAlertModelRepository(json);

  static List<AlertModelRepository> _safeToListAlertModelRepository(Map<String, dynamic> json) {
    List<AlertModelRepository> _data;
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(AlertModelRepository.fromJson(v as Map<String, dynamic>));
      });
    }
    return _data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlertModelRepository {
  final int id;
  final int bolusId;
  final int cowId;
  final int farmId;
  final String type;
  final String message;
  final String created;
  final String value;
  final EventModelRepository event;
  final String farmName;
  final String hoursBack;
  final int percent;
  final List<NotificationModelRepository> notifications;
  final FeedbackModelRepository feedback;
  final bool opened;

  AlertModelRepository(
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

  AlertModelRepository.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        bolusId = json['bolusId'] as int,
        cowId = json['cowId'] as int,
        farmId = json['farmId'] as int,
        type = json['type'] as String,
        message = json['message'] as String,
        created = json['created'] as String,
        value = json['value'] as String,
        event = _safeEventModelRepository(json),
        farmName = json['farmName'] as String,
        hoursBack = json['hoursBack'] as String,
        percent = json['percent'] as int,
        notifications = _safeToListNotificationModelRepository(json),
        feedback = _safeFeedbackModelRepository(json),
        opened = json['opened'] as bool;

  static FeedbackModelRepository _safeFeedbackModelRepository(Map<String, dynamic> json) {
    try {
      return json['feedback'] != null
          ? FeedbackModelRepository.fromJson(json['feedback'] as Map<String, dynamic>)
          : null;
    } catch (e) {
      return null;
    }
  }

  static EventModelRepository _safeEventModelRepository(Map<String, dynamic> json) {
    try {
      return json['event'] != null ? EventModelRepository.fromJson(json['event'] as Map<String, dynamic>) : null;
    } catch (e) {
      return null;
    }
  }

  static List<NotificationModelRepository> _safeToListNotificationModelRepository(Map<String, dynamic> json) {
    List<NotificationModelRepository> _notifications;
    if (json['notifications'] != null) {
      _notifications = [];
      json['notifications'].forEach((v) {
        _notifications.add(NotificationModelRepository.fromJson(v as Map<String, dynamic>));
      });
    }
    return _notifications;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bolusId'] = bolusId;
    data['cowId'] = cowId;
    data['farmId'] = farmId;
    data['type'] = type;
    data['message'] = message;
    data['created'] = created;
    data['value'] = value;
    if (event != null) {
      data['event'] = event.toJson();
    }
    data['farmName'] = farmName;
    data['hoursBack'] = hoursBack;
    data['percent'] = percent;
    if (notifications != null) {
      data['notifications'] = notifications.map((v) => v.toJson()).toList();
    }
    if (feedback != null) {
      data['feedback'] = feedback.toJson();
    }
    data['opened'] = opened;
    return data;
  }
}

class EventModelRepository {
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

  EventModelRepository(
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

  EventModelRepository.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        objectId = json['objectId'] as int,
        farmId = json['farmId'] as int,
        eventType = json['eventType'] as String,
        date = json['date'] as String,
        description = json['description'] as String,
        name = json['name'] as String,
        remark = json['remark'] as String,
        result = json['result'] as String,
        daysInMilk = json['daysInMilk'] as int,
        protocols = json['protocols'] as String,
        alerts = json['alerts']?.cast<int>() as List<int>;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['objectId'] = objectId;
    data['farmId'] = farmId;
    data['eventType'] = eventType;
    data['date'] = date;
    data['description'] = description;
    data['name'] = name;
    data['remark'] = remark;
    data['result'] = result;
    data['daysInMilk'] = daysInMilk;
    data['protocols'] = protocols;
    data['alerts'] = alerts;
    return data;
  }
}

class EventFullModelRepository {
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
  final List<AlertModelRepository> alerts;

  EventFullModelRepository(
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

  EventFullModelRepository.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        objectId = json['objectId'] as int,
        farmId = json['farmId'] as int,
        eventType = json['eventType'] as String,
        date = json['date'] as String,
        description = json['description'] as String,
        name = json['name'] as String,
        remark = json['remark'] as String,
        result = json['result'] as String,
        daysInMilk = json['daysInMilk'] as int,
        protocols = json['protocols'] as String,
        alerts = _safeToListAlertModelRepository(json);

  static List<AlertModelRepository> _safeToListAlertModelRepository(Map<String, dynamic> json) {
    List<AlertModelRepository> _alerts;
    if (json['alerts'] != null) {
      _alerts = [];
      json['alerts'].forEach((v) {
        _alerts.add(AlertModelRepository.fromJson(v as Map<String, dynamic>));
      });
    }
    return _alerts;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['objectId'] = objectId;
    data['farmId'] = farmId;
    data['eventType'] = eventType;
    data['date'] = date;
    data['description'] = description;
    data['name'] = name;
    data['remark'] = remark;
    data['result'] = result;
    data['daysInMilk'] = daysInMilk;
    data['protocols'] = protocols;
    data['alerts'] = alerts;
    return data;
  }
}

class NotificationModelRepository {
  final int id;
  final String receiver;
  final String created;
  final String body;
  final bool isRead;
  final bool feedback;

  NotificationModelRepository(
    this.id,
    this.receiver,
    this.created,
    this.body,
    this.isRead,
    this.feedback,
  );

  NotificationModelRepository.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        receiver = json['receiver'] as String,
        created = json['created'] as String,
        body = json['body'] as String,
        isRead = json['isRead'] as bool,
        feedback = json['feedback'] as bool;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['receiver'] = receiver;
    data['created'] = created;
    data['body'] = body;
    data['isRead'] = isRead;
    data['feedback'] = feedback;
    return data;
  }
}

class FeedbackModelRepository {
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

  FeedbackModelRepository(
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

  FeedbackModelRepository.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        created = json['created'] as String,
        visualSymptoms = json['visualSymptoms'] as bool,
        rectalTemperature = json['rectalTemperature'] as double,
        rectalTemperatureTime = json['rectalTemperatureTime'] as String,
        treatmentNote = json['treatmentNote'] as String,
        generalNote = json['generalNote'] as String,
        milkDropped = json['milkDropped'] as bool,
        putToSort = json['putToSort'] as bool,
        useful = json['useful'] as bool,
        diagnosis = json['diagnosis'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['alert_id'] = id;
    data['created'] = created;
    data['visualSymptoms'] = visualSymptoms;
    data['rectalTemperature'] = rectalTemperature;
    data['rectalTemperatureTime'] = rectalTemperatureTime;
    data['treatmentNote'] = treatmentNote;
    data['generalNote'] = generalNote;
    data['milkDropped'] = milkDropped;
    data['putToSort'] = putToSort;
    data['useful'] = useful;
    data['diagnosis'] = diagnosis;
    return data;
  }
}
