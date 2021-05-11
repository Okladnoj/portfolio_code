class StateRightSheet {
  final double width;
  final bool isOpen;
  final bool refreshKey;

  StateRightSheet(
    this.width,
    this.isOpen,
    this.refreshKey,
  );

  StateRightSheet copy({double width, bool isOpen, bool refreshKey}) {
    return StateRightSheet(
      width ?? this.width,
      isOpen ?? this.isOpen,
      refreshKey ?? this.refreshKey,
    );
  }
}
