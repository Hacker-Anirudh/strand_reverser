import 'logic.dart';
import 'dart:io';
import 'shared.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Importlogic {
  static 
  Future<void> importLogic(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        final csvData = await file.readAsString();
        List<String> rows = csvData
            .split('\n')
            .map((row) => row.trim())
            .toList();
        rows.removeWhere((row) => row.isEmpty || row == 'Sequences');
        List<List<String>> outputRows = [
          ['Sequence', 'Reverse', 'Reverse-Complement', 'Complement']
        ];
        List<String> invalidSequences = [];

        for (String inputSequence in rows) {
          inputSequence = inputSequence.toUpperCase();

          if (inputSequence.contains(RegExp(r'[^ATGC]'))) {
            invalidSequences.add(inputSequence);
            continue; // Skip invalid sequence
          }

          String reverse = Logic.reverseDNA(inputSequence);
          String complement = Logic.complementDNA(inputSequence);
          String reverseComplement = Logic.reversecomplementDNA(inputSequence);
          outputRows.add(
              [inputSequence, reverse, reverseComplement, complement]);
        }

        String? outputFilePath = await Shared.makeFileName('processed_sequences');
        if (outputFilePath != null) {
          File outputFile = File(outputFilePath);
          String csvOutput = const ListToCsvConverter().convert(outputRows);
          await outputFile.writeAsString(csvOutput);

          String dialogMessage = 'CSV exported to: $outputFilePath';
          if (invalidSequences.isNotEmpty) {
            dialogMessage +=
            '\n\nInvalid sequences skipped:\n${invalidSequences.join(", ")}';
          }

          if (context.mounted) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: const Text('Export Successful'),
                    content: Text(dialogMessage),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
            );
          }
        } else {
          Shared.showErrorDialog(context, 'Unable to create output file.');
        }
      } else {
        Shared.showErrorDialog(context, 'No file selected.');
      }
    } catch (e) {
      Shared.showErrorDialog(
          context, 'An error occurred while importing or exporting: $e');
    }
  }
}