import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';

class Shared {
  // Helper function to show error dialogs
  static void showErrorDialog(BuildContext context, String message) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<String?> makeFileName(BuildContext context, name) async {
    String? directory = await getDirectoryPath();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd_HH-mm-ss').format(now);
    if (directory == null) {
      Shared.showErrorDialog(context, 'Directory is NULL');
    }
    final path = '$directory/$formattedDate-$name.csv';
    return path;
  }
}
