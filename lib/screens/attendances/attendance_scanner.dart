import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/services/attendance_service.dart';
import 'package:hrms_app/services/location_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AttendanceScannerScreen extends StatefulWidget {
  const AttendanceScannerScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScannerScreenState createState() =>
      _AttendanceScannerScreenState();
}

class _AttendanceScannerScreenState extends State<AttendanceScannerScreen> {
  final AttendanceService _attendanceService = AttendanceService();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;
  BuildContext? dialogContext;
  Position? _position;

  bool _isLoading = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Scan RQ Code'), centerTitle: true),
        body: LoadingOverlay(
          isLoading: _isLoading,
          opacity: 0.2,
          child: Column(
            children: <Widget>[
              Expanded(
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(),
                ),
              ),
            ],
          ),
        ));
  }

  void _onQRViewCreated(QRViewController qrController) {
    this.qrController = qrController;
    qrController.scannedDataStream.listen((scanData) {
      if (scanData.code == null) return;
      qrController.stopCamera();
      setState(() {
        result = scanData;
      });

      try {
        final Map<String, dynamic> qrCodeData = jsonDecode(result!.code ?? '');
        _checkAttendance(qrCodeData);
      } on FormatException catch (_, e) {
        qrController.resumeCamera();
        throw 'Invalided QR code format. $e';
      }
    });
  }

  void showMessage(BuildContext context, String message) {
    Widget btnTryAgain = TextButton(
      child: const Text("Try again"),
      onPressed: () {
        Navigator.pop(dialogContext!);
        qrController!.resumeCamera();
      },
    );
    Widget btnCancel = TextButton(
      child: const Text("No, thanks"),
      onPressed: () {
        Navigator.pop(dialogContext!);
        _goBack();
      },
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            title: const Text(
              "Error!",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(message),
            actions: [
              btnCancel,
              btnTryAgain,
            ],
            elevation: 5,
          );
        },
        barrierDismissible: false);
  }

  void _checkAttendance(Map<String, dynamic> qrCodeData) async {
    _isLoading = true;
    _position ??= await LocationService().getCurrentLocation();
    Map<String, dynamic> body = {
      'qrcodeId': qrCodeData['id'],
      'userLat': _position?.latitude,
      'userLng': _position?.longitude,
      'description': '',
    };

    ResponseDTO res = await _attendanceService.checkAttendance(body);
    debugPrint('========== Data Response ${res.toJson()}');
    if (!context.mounted) return;
    setState(() {
      _isLoading = false;
    });

    if (res.statusCode == 200) {
      _goBack();
    }

    if (res.statusCode == 400 || res.statusCode == 500) {
      showMessage(context, res.message);
    }
  }

  void _goBack() {
    GoRouter.of(context).pop();
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}
