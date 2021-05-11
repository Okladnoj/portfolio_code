import 'package:cattle_scan/views/alerts/models/alert_model_ui.dart';

class EventsModelUI {
  final String status;
  final List<EventFullModelUI> eventsFull;
  final List<EventModelUI> events;

  EventsModelUI(
    this.status,
    this.eventsFull,
    this.events,
  );
}
