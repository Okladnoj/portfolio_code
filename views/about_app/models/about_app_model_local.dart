class AboutAppModelLocal {
  final AppInfoModelLocal appInfoModel;
  final DeviceInfoModelLocal deviceInfoModel;
  final OurContactsModelLocal ourContactsModel;

  AboutAppModelLocal(
    this.appInfoModel,
    this.deviceInfoModel,
    this.ourContactsModel,
  );
}

class AppInfoModelLocal {
  final String title;
  final String version;

  AppInfoModelLocal(
    this.title,
    this.version,
  );
}

class DeviceInfoModelLocal {
  final String title;
  final String version;
  final String model;
  final String brand;

  DeviceInfoModelLocal(
    this.title,
    this.version,
    this.model,
    this.brand,
  );
}

class OurContactsModelLocal {
  final String title;
  final String address;
  final String phone;
  final String email;

  OurContactsModelLocal(
    this.title,
    this.address,
    this.phone,
    this.email,
  );
}
