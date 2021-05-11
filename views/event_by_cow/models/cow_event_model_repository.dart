import 'package:cattle_scan/views/alerts/models/alert_model_repository.dart';

class EventsModelRepository {
  final String status;
  final List<EventFullModelRepository> events;

  EventsModelRepository(
    this.status,
    this.events,
  );

  EventsModelRepository.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        events = _safeToListEventModelRepository(json);

  static List<EventFullModelRepository> _safeToListEventModelRepository(Map<String, dynamic> json) {
    List<EventFullModelRepository> data;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(EventFullModelRepository.fromJson(v as Map<String, dynamic>));
      });
    }
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (events != null) {
      data['data'] = events.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
