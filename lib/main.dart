// This project is STRICTLY for Windows, macOS, or GNU/Linux. This is due to the more open nature of these platforms making it easier to develop for.
import 'exportlogic.dart';
import 'package:flutter/material.dart';
import 'importlogic.dart';
import 'shared.dart';
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
  bool isDark = true;
  TextEditingController textController = TextEditingController();

  // This is the MaterialApp widget for the app

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      home: Scaffold(
        floatingActionButton: changemode(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button5(context),
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button2(context),
                            const SizedBox(height: 8),
                            button3(context),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button2(context),
                            const SizedBox(width: 8),
                            button3(context),
                          ],
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton changemode() {
    return FloatingActionButton(
      onPressed: () {},
      child: Tooltip(
        message: 'Switch mode',
        child: IconButton(
          isSelected: isDark,
          onPressed: () {
            setState(() {
              isDark = !isDark;
            });
          },
          icon: const Icon(Icons.wb_sunny_outlined),
          selectedIcon: const Icon(Icons.brightness_2_outlined),
        ),
      ),
    );
  }

  Padding textField1() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: TextField(
          controller: textController,
          onSubmitted: (_) => processInput(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter the DNA sequence here.',
          ),
        ),
      ),
    );
  }

  void processInput() {
    String input = textController.text.toUpperCase();
    if (input.contains(RegExp(r'[^ATGC]'))) {
      Shared.showErrorDialog(context,
          'You have not entered a valid DNA sequence, please try again.');
    } else {
      setstate(input);
    }
    textController.clear();
  }

  Padding button1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: processInput,
        child: const Text('Process'),
      ),
    );
  }

  Padding button5(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: ElevatedButton(
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: 'DNA Strand Reverser',
              applicationVersion: '1.1',
              applicationLegalese:
                  'GNU GPL v3 License\n© 2020-2025 Anirudh Menon. All rights reserved.',
              children: [
                const Text(
                    'This application is a simple DNA sequence reverser. It can reverse, complement, and reverse-complement DNA sequences.'),
              ],
              applicationIcon: Image.asset('assets/strand_reverser64.png'),
            );
          },
          child: const Text('About this application')),
    );
  }

  Widget title(String text, {EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: SelectableText(
        text,
        style: TextStyle(
            fontSize: (MediaQuery.of(context).size.width +
                    MediaQuery.of(context).size.height) /
                72,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Padding button3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () async {
          await exportLogic(context, sequence, reverseSequence,
              reversedSequence, complementSequence);
        },
        child: const Text('Export to CSV'),
      ),
    );
  }

  Padding button2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
          onPressed: () => Importlogic.importLogic(context),
          child: const Text('Import and process CSV')),
    );
  }

  Padding seq(String text, {EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(12.0),
      child: SelectableText(
        text,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: (MediaQuery.of(context).size.width +
                  MediaQuery.of(context).size.height) /
              65,
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
