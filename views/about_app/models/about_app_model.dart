class AboutAppModel {
  final AppInfoModel appInfoModel;
  final DeviceInfoModel deviceInfoModel;
  final OurContactsModel ourContactsModel;

  AboutAppModel(
    this.appInfoModel,
    this.deviceInfoModel,
    this.ourContactsModel,
  );
  factory AboutAppModel.empty() => AboutAppModel(
        AppInfoModel('App info', null),
        DeviceInfoModel('Your device info', null, null, null),
        OurContactsModel('Our contacts', null, null, null),
      );
}

class AppInfoModel {
  final String title;
  final String version;

  AppInfoModel(
    this.title,
    this.version,
  );
}

class DeviceInfoModel {
  final String title;
  final String version;
  final String model;
  final String brand;

  DeviceInfoModel(
    this.title,
    this.version,
    this.model,
    this.brand,
  );
}

class OurContactsModel {
  final String title;
  final String address;
  final String phone;
  final String email;

  OurContactsModel(
    this.title,
    this.address,
    this.phone,
    this.email,
  );
}
