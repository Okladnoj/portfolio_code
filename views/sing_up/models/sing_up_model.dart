class SingUpModel {
  final String nameFarm;
  final String nameFarmer;
  final String email;
  final String password;

  SingUpModel(
    this.nameFarm,
    this.nameFarmer,
    this.email,
    this.password,
  );

  SingUpModel copy({
    String nameFarm,
    String nameFarmer,
    String email,
    String password,
  }) {
    return SingUpModel(
      nameFarm ?? this.nameFarm,
      nameFarmer ?? this.nameFarmer,
      email ?? this.email,
      password ?? this.password,
    );
  }

  factory SingUpModel.empty() {
    return SingUpModel(
      null,
      null,
      null,
      null,
    );
  }
}
