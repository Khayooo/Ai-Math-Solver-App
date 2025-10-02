import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ExtractTextScreen extends StatefulWidget {

  final File image;

  const ExtractTextScreen({super.key, required this.image});

  @override
  State<ExtractTextScreen> createState() => _ExtractTextScreenState();
}

class _ExtractTextScreenState extends State<ExtractTextScreen> {

  String? extractedText;
  final model = GenerativeModel(
    model: "gemini-2.5-flash",
    apiKey: "AIzaSyB7NToCpz_ckbWPpQ01ApEEQGHRy-EyMR0",
  );

  @override
  void initState() {
    super.initState();
    _extractText();
  }

  Future<void> _extractText() async {
    final response = await model.generateContent([
      Content.multi([
        TextPart("Extract all text from this image."),
        DataPart('image/jpeg', await widget.image.readAsBytes()),
      ])
    ]);

    setState(() => extractedText = response.text);
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: const Text("Step 2: Extracted Text")),
      body: extractedText == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Text(extractedText!,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         PromptScreen(extractedText: extractedText!),
              //   ),
              // );
            },
            child: const Text("Next → Give Prompt"),
          ),
        ],
      ),
    );
  }
  }

