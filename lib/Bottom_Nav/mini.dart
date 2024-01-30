import 'package:flutter/material.dart';
import 'package:hive_flutter_app/Utils/qr_scanner.dart';

class MiniHiveScreen extends StatefulWidget {
  const MiniHiveScreen({super.key});

  @override
  State<MiniHiveScreen> createState() => _MiniHiveScreenState();
}

class _MiniHiveScreenState extends State<MiniHiveScreen> {
  String? qrText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('MIni Hive'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openScannerPopup(context);
        },
        child: Icon(Icons.qr_code_scanner),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _openScannerPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 300,
          width: 300,
          child: QRScannerWidget(onScanned: (code) {
            setState(() {
              qrText = code;
            });
            // Handle the scanned QR code if necessary
            Navigator.of(context).pop(); // Close the popup after scanning
          }),
        ),
        actions: [
          Column(
            children: [
              Center(
                child: Text(
                  'Scan Result: ${qrText ?? 'loading...'}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
