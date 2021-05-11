import 'dart:io';

import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCode extends StatefulWidget {
  final Future<void> Function(String value) onChanged;
  final ValueNotifier<bool> isEnable;

  const ScanQrCode({
    Key key,
    this.onChanged,
    this.isEnable,
  }) : super(key: key);
  @override
  _ScanQrCodeState createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  bool isOpen = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget?.isEnable?.value ?? false)) {
      return Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: _buildDesignButton('First, enter animal id', false),
      );
    }
    return isOpen ? _buildScanner(context) : _buildButton('Scan QR-code by bolus', true);
  }

  Widget _buildScanner(BuildContext context) {
    return Stack(
      alignment: const Alignment(0, 1),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildButton('Close Camera', false),
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (widget.onChanged != null) {
        if (isOpen) {
          widget.onChanged(scanData.code);
          try {
            HapticFeedback.heavyImpact();
          } catch (e) {
            print(e);
          }
        }
        setState(() {
          isOpen = false;
        });
        isOpen = false;
      }
    });
  }

  Widget _buildButton(String string, bool opened) {
    return Hero(
      tag: 'scanQrCode',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: InkCustomButton(
          height: 40,
          onTap: () {
            setState(() {
              isOpen = opened;
            });
          },
          child: _buildDesignButton(string, true),
        ),
      ),
    );
  }

  Widget _buildDesignButton(String string, bool isEnable) {
    return Container(
      width: double.maxFinite,
      alignment: const Alignment(0, 0),
      decoration: DesignStile.buttonDecoration(
        colorBoxShadow: DesignStile.grey,
        blurRadius: 10,
        offset: const Offset(0, 2),
        colorBorder: isEnable ? DesignStile.primary : DesignStile.grey,
        color: isEnable ? DesignStile.primary : DesignStile.grey,
      ),
      child: Text(
        string,
        style: DesignStile.textStyleCustom(
          color: isEnable ? DesignStile.white : DesignStile.disable,
          fontSize: 20,
        ),
      ),
    );
  }
}
