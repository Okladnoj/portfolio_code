enum CheckCow {
  absent,
  present,
  error,
}

class CowAddModel {
  final String bolusId;
  final String animalId;
  final CheckCow checkCow;
  final DateTime dateOfBirth;
  final int lactationNumber;
  final String lactationStage;
  final DateTime dateLactationStart;

  CowAddModel(
    this.bolusId,
    this.animalId,
    this.checkCow,
    this.dateOfBirth,
    this.lactationNumber,
    this.lactationStage,
    this.dateLactationStart,
  );

  CowAddModel copy({
    String bolusId,
    String animalId,
    CheckCow checkCow,
    DateTime dateOfBirth,
    int lactationNumber,
    String lactationStage,
    DateTime dateLactationStart,
  }) {
    return CowAddModel(
      bolusId ?? this.bolusId,
      animalId ?? this.animalId,
      checkCow ?? this.checkCow,
      dateOfBirth ?? this.dateOfBirth,
      lactationNumber ?? this.lactationNumber,
      lactationStage ?? this.lactationStage,
      dateLactationStart ?? this.dateLactationStart,
    );
  }

  factory CowAddModel.empty() => CowAddModel(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
      );
}
