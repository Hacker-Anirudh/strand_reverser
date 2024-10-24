// This project is STRICTLY for Windows, macOS, or GNU/Linux. This is due to the more open nature of these platforms making it easier to develop for.

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

// The main function. Duh.

void main() {
  runApp(const MyApp());
}

// Main app function

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

// Homepage class

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

// Declare variables for the seqeunces later

String reversedSequence = '';
String reverseSequence = '';
String complementSequence = '';
String sequence = '';
String reversedSequence1 = '';
String reverseSequence1 = '';
String complementSequence1 = '';
String sequence1 = '';
// This contains most of the logic of the app

class HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();

  String _reversecomplementDNA(String sequence) {
    Map<String, String> complementMap = {
      'A': 'T',
      'T': 'A',
      'C': 'G',
      'G': 'C',
    };

    return sequence.split('').toList().reversed.map((nucleotide) {
      return complementMap[nucleotide];
    }).join();
  }

  String _reverseDNA(String sequence) {
    return sequence.split('').reversed.join();
  }

  String _complementDNA(String sequence) {
    Map<String, String> complementMap = {
      'A': 'T',
      'T': 'A',
      'C': 'G',
      'G': 'C',
    };

    return sequence.split('').toList().map((nucleotide) {
      return complementMap[nucleotide];
    }).join();
  }

  // This is the MaterialApp widget for the app

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        floatingActionButton: infoButton(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textField1(),
              button1(context),
              seq(sequence),
              title('Reverse'),
              seq(reverseSequence),
              title('Complement'),
              seq(complementSequence),
              title('Reverse-Complement'),
              seq(reversedSequence),
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // button2(),
                    button3(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton infoButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('About'),
            content: const Text(
                'Copyright 2024 Hacker-Anirudh. Licensed under GNU GPL v3 license.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Close'),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: const Icon(Icons.info),
    );
  }

  Padding textField1() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: SizedBox(
        width: 420,
        height: 69,
        child: TextField(
          controller: textController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter the DNA sequence here.',
          ),
        ),
      ),
    );
  }

  Padding button1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: ElevatedButton(
        onPressed: () {
          String input = textController.text.toUpperCase();
          if (input.contains(RegExp(r'[^ATGC]'))) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'You have not entered a valid DNA sequence. Please try again'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            setstat(input);
          }
          textController.clear();
        },
        child: const Text('Process'),
      ),
    );
  }

  void setstat(String input) {
    return setState(() {
      reversedSequence = _reversecomplementDNA(input);
      reverseSequence = _reverseDNA(input);
      complementSequence = _complementDNA(input);
      sequence = input;
    });
  }

  Padding title(String title) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 31,
        ),
      ),
    );
  }

  Padding seq(String text) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Text(
        text,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 13,
        ),
      ),
    );
  }

  Padding button3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          if (sequence.isEmpty) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: const Text('Error'),
                    content: const Text('No DNA sequence available to export.'),
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
            return;
          }

          List<List<String>> rows = [
            ['Input', 'Reverse', 'Complement', 'Reverse-Complement'],
            [sequence, reverseSequence, complementSequence, reversedSequence],
          ];
          String csv = const ListToCsvConverter().convert(rows);

          final directory = await FilePicker.platform.getDirectoryPath();
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd_HH-mm-ss').format(now);
          final path = '$directory/$formattedDate-dna_sequences.csv';

          File file = File(path);
          await file.writeAsString(csv);
          if (context.mounted) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
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
          },
        child: const Text('Export to CSV'),
      ),
    );
  }
}
