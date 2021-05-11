import 'package:cattle_scan/views/alerts/models/alert_model.dart';

class EventsModel {
  final String status;
  final List<EventFullModel> events;

  EventsModel(
    this.status,
    this.events,
  );

  EventsModel copy({
    String status,
    List<EventFullModel> events,
  }) {
    return EventsModel(
      status ?? this.status,
      events ?? this.events,
    );
  }
}
