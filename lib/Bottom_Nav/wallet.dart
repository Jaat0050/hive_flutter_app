import 'package:flutter/material.dart';
import 'package:hive_flutter_app/Utils/qr_scanner.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // late QRViewController controller;
  String? qrText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Wallet'),
      ),
      body: Container(
        child: Column(
          children: [
            Center(child: QRScannerWidget(onScanned: (code) {
              setState(() {
                qrText = code;
              });
            })),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  'Scan Result: ${qrText ?? 'loading...'}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       qrText = scanData.code;
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }
}
