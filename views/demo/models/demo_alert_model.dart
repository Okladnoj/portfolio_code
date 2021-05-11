class DemoAlertModel {
  final bool isSend;

  DemoAlertModel(
    this.isSend,
  );

  DemoAlertModel copy({
    bool isSend,
  }) {
    return DemoAlertModel(
      isSend ?? this.isSend,
    );
  }
}
