class CowUpdateModel {
  final int animalId;
  final String lactationStage;
  final DateTime dateLactationStart;

  CowUpdateModel(
    this.animalId,
    this.lactationStage,
    this.dateLactationStart,
  );
  CowUpdateModel copy({
    int animalId,
    String lactationStage,
    DateTime dateLactationStart,
  }) {
    return CowUpdateModel(
      animalId ?? this.animalId,
      lactationStage ?? this.lactationStage,
      dateLactationStart ?? this.dateLactationStart,
    );
  }
}
