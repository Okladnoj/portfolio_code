import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

import '../models/about_app_model.dart';
import '../models/about_app_model_local.dart';

class AboutAppRepository {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // Package info
  String _appVersion;
  // String _appBuildNumber;
  // Device info
  String _deviceName;
  String _deviceManufacturer;
  String _deviceOsVersion;
  // String _token;

  AboutAppModelLocal _aboutAppModelLocal;
  Future<AboutAppModel> loadData() async {
    await _getInfo();
    _aboutAppModelLocal = AboutAppModelLocal(
      _getAppInfoModelLocal(),
      _getDeviceInfoModelLocal(),
      _getOurContactsModelLocal(),
    );
    return AboutAppModel(
      AppInfoModel(
        _aboutAppModelLocal?.appInfoModel?.title,
        _aboutAppModelLocal?.appInfoModel?.version,
      ),
      DeviceInfoModel(
        _aboutAppModelLocal?.deviceInfoModel?.title,
        _aboutAppModelLocal?.deviceInfoModel?.version,
        _aboutAppModelLocal?.deviceInfoModel?.model,
        _aboutAppModelLocal?.deviceInfoModel?.brand,
      ),
      OurContactsModel(
        _aboutAppModelLocal?.ourContactsModel?.title,
        _aboutAppModelLocal?.ourContactsModel?.address,
        _aboutAppModelLocal?.ourContactsModel?.phone,
        _aboutAppModelLocal?.ourContactsModel?.email,
      ),
    );
  }

  AppInfoModelLocal _getAppInfoModelLocal() {
    return AppInfoModelLocal(
      'App info',
      'App version: $_appVersion',
    );
  }

  DeviceInfoModelLocal _getDeviceInfoModelLocal() {
    return DeviceInfoModelLocal(
      'Your device info',
      'OS version: $_deviceOsVersion',
      'Device model: $_deviceName',
      'Device manufacturer: $_deviceManufacturer',
    );
  }

  OurContactsModelLocal _getOurContactsModelLocal() {
    return OurContactsModelLocal(
      'Our contacts',
      'Address: 44 Gerrard Street East, Toronto, Ontario, Canada, M5B 1G3',
      'Phone number: +1-855-9999-114',
      'Email: info@cattlescan.ca',
    );
  }

  Future<void> _getInfo() async {
    // Package info
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }

    // Package info
    _appVersion = packageInfo.version;
    //  _appBuildNumber = packageInfo.buildNumber;
    // Device info
    _deviceName = deviceData['model'] as String;
    if (Platform.isAndroid) {
      _deviceOsVersion = 'Android ${deviceData['version.release']}';
      _deviceManufacturer = deviceData['manufacturer'] as String;
    } else if (Platform.isIOS) {
      _deviceOsVersion = 'iOS ${deviceData['systemVersion']}';
      _deviceManufacturer = 'Apple';
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
