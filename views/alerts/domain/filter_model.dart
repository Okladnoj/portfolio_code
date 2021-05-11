class FilterToAlerts {
  final String key;
  final String nameScreen;
  final List<String> listKeys;
  final Map<String, String> mapKeys;

  FilterToAlerts({
    this.nameScreen = 'List of Alerts',
    this.listKeys = const [],
    this.mapKeys = const {},
    this.key = 'alertListfull',
  });
}
