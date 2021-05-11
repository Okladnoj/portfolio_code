import 'package:flutter/material.dart';

import 'app/cattle_scan.dart';
import 'pre_start_app/pre_start_app.dart';

Future<void> main() async {
  await _applySettings();
  runApp(CattleScan());
}

Future _applySettings() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreStartApp().applySettings();
}
