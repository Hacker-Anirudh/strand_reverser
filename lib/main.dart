import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController(); 
  String reversedSequence = ''; 

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Enter the DNA sequence you want to reverse."),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoTextField(
                controller: textController, 
                placeholder: "Enter DNA sequence",
                textAlign: TextAlign.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(105, 255, 255, 255),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: CupertinoColors.black,
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 20.0),
              CupertinoButton.filled(
                child: const Text('Reverse'),
                onPressed: () {
                  String input = textController.text.toUpperCase(); 
                  setState(() {
                    reversedSequence = _reversecomplementDNA(input); 
                    textController.clear(); 
                  });
                },
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Reverse-Complement:',
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
              const SizedBox(height: 10.0),
              Text(
                reversedSequence,
                style: const TextStyle(fontSize: 28.0, color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

String _reversecomplementDNA(String sequence) {
  Map<String, String> complementMap = {
    'A': 'T',
    'T': 'A',
    'C': 'G',
    'G': 'C',
  };

  return sequence.split('').toList().reversed.map((nucleotide) {
    return complementMap.containsKey(nucleotide) ? complementMap[nucleotide] : "Invalid_nucleotide ";
  }).join();
}

}