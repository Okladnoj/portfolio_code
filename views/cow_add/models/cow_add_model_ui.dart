import 'cow_add_model.dart';

class CowAddModelUI {
  final String bolusId;
  final String animalId;
  final CheckCow checkCow;
  final String dateOfBirth;
  final String lactationNumber;
  final String lactationStage;
  final String dateLactationStart;

  CowAddModelUI(
    this.bolusId,
    this.animalId,
    this.checkCow,
    this.dateOfBirth,
    this.lactationNumber,
    this.lactationStage,
    this.dateLactationStart,
  );

  bool get isValidate =>
      (animalId?.isNotEmpty ?? false) && //
      (bolusId?.isNotEmpty ?? false) &&
      (checkCow == CheckCow.absent);
}
