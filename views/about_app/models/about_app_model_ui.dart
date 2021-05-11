class AboutAppModelUI {
  final AppInfoModelUI appInfoModel;
  final DeviceInfoModelUI deviceInfoModel;
  final OurContactsModelUI ourContactsModel;

  AboutAppModelUI(
    this.appInfoModel,
    this.deviceInfoModel,
    this.ourContactsModel,
  );
}

class AppInfoModelUI {
  final String title;
  final String version;

  AppInfoModelUI(
    this.title,
    this.version,
  );
}

class DeviceInfoModelUI {
  final String title;
  final String version;
  final String model;
  final String brand;

  DeviceInfoModelUI(
    this.title,
    this.version,
    this.model,
    this.brand,
  );
}

class OurContactsModelUI {
  final String title;
  final String address;
  final String phone;
  final String email;

  OurContactsModelUI(
    this.title,
    this.address,
    this.phone,
    this.email,
  );
}
