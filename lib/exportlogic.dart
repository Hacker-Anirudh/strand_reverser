import 'package:flutter/material.dart';
import 'dart:io';
import 'shared.dart';
import 'package:csv/csv.dart';

Future<void> exportLogic(
    BuildContext context,
    String sequence,
    String reverseSequence,
    String reversedSequence,
    String complementSequence) async {
  if (sequence.isEmpty) {
    Shared.showErrorDialog(context, 'No valid DNA sequence detected.');
  } else {
    List<List<String>> rows = [
      ['Input', 'Reverse', 'Complement', 'Reverse-Complement'],
      [sequence, reverseSequence, complementSequence, reversedSequence],
    ];
    String csv = const ListToCsvConverter().convert(rows);

    String? path = await Shared.makeFileName(context, 'dna_sequence');

    if (path != null) {
      try {
        File file = File(path);
        await file.writeAsString(csv);
      } catch (error) {
        Shared.showErrorDialog(
            context, 'An error occurred while exporting : $error');
      }

      if (context.mounted) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Export Successful'),
            content: Text('CSV exported to: $path'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (context.mounted) {
                    Navigator.pop(context, 'OK');
                  } else {
                    exit(0);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        exit(0);
      }
    } else {
      Shared.showErrorDialog(context, 'Failed to generate file path.');
    }
  }
}
