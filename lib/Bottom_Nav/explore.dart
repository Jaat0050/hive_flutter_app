import 'package:flutter/material.dart';
import 'package:hive_flutter_app/Utils/qr_scanner.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String? qrText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Explore'),
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
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: QRScannerWidget(onScanned: (code) {
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
