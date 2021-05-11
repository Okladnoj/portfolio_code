class SingUpModelUI {
  final String nameFarm;
  final String nameFarmer;
  final String email;
  final String password;

  SingUpModelUI(
    this.nameFarm,
    this.nameFarmer,
    this.email,
    this.password,
  );
  bool get isValidate =>
      (nameFarm?.isNotEmpty ?? false) && //
      (nameFarmer?.isNotEmpty ?? false) &&
      (email?.isNotEmpty ?? false) &&
      (password?.isNotEmpty ?? false);
}
