// This project is STRICTLY for Windows, macOS, or GNU/Linux. This is due to the more open nature of these platforms making it easier to develop for.

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'importlogic.dart';
import 'shared.dart';
import 'package:logger/logger.dart';
import 'logic.dart';
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

// Declare variables for the sequences later

String reversedSequence = '';
String reverseSequence = '';
String complementSequence = '';
String sequence = '';
// This contains most of the logic of the app

class HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();
  var logger = Logger();

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
                    button2(context),
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
        showAboutDialog(
          context: context,
          applicationName: 'DNA Strand Reverser',
          applicationVersion: '1.0.1',
          applicationLegalese: 'GNU GPL v3 License',
          applicationIcon: Image.asset('assets/strand_reverser64.png'),
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
            Shared.showErrorDialog(context,
                'You have not entered a valid DNA sequence, please try again.');
          } else {
            setstate(input);
          }
          textController.clear();
        },
        child: const Text('Process'),
      ),
    );
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

  Padding button3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          await exportLogic(
              context, sequence, reverseSequence, reversedSequence,
              complementSequence);
        },
        child: const Text('Export to CSV'),
      ),);
  }

  Padding button2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: () => Importlogic.importLogic(context),
          child: const Text ('Import and process CSV')),

    );
  }

  Future<void> exportLogic(BuildContext context, String sequence,
      String reverseSequence, String reversedSequence,
      String complementSequence) async {
    if (sequence.isEmpty) {
      Shared.showErrorDialog(context, 'No valid DNA sequence detected.');
    } else {
      List<List<String>> rows = [
        ['Input', 'Reverse', 'Complement', 'Reverse-Complement'],
        [sequence, reverseSequence, complementSequence, reversedSequence],
      ];
      String csv = const ListToCsvConverter().convert(rows);

      String? path = await Shared.makeFileName('dna_sequence');

      if (path != null) {
        try {
          File file = File(path);
          await file.writeAsString(csv);
        } catch (error) {
          Shared.showErrorDialog(context, 'An error occurred while exporting : $error');
        }

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
                          logger.f(
                              'App terminating due to context not being mounted');
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

  void setstate(String input) {
    return setState(() {
      reversedSequence = Logic.reversecomplementDNA(input);
      reverseSequence = Logic.reverseDNA(input);
      complementSequence = Logic.complementDNA(input);
      sequence = input;
    });
  }

  


}