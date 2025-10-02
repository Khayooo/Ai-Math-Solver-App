import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class PromtpScreen extends StatefulWidget {

  final String extractedText;

  const PromtpScreen({super.key, required this.extractedText});

  @override
  State<PromtpScreen> createState() => _PromtpScreenState();
}

class _PromtpScreenState extends State<PromtpScreen> {

  final _controller = TextEditingController();
  String? aiResponse;

  final model = GenerativeModel(
    model: "gemini-2.5-flash",
    apiKey: "AIzaSyB7NToCpz_ckbWPpQ01ApEEQGHRy-EyMR0", // Replace with your Gemini API Key
  );

  Future<void> _sendPrompt() async {
    final prompt = _controller.text;
    final response = await model.generateContent([
      Content.text("Extracted Text: ${widget.extractedText}\n\nUser Prompt: $prompt")
    ]);

    setState(() {
      aiResponse = response.text ?? "No response from AI";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Step 3: Prompt & Response")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text("Extracted Text:\n${widget.extractedText}",
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            TextField(
              controller: _controller,
              decoration:
              const InputDecoration(labelText: "Enter your prompt here"),
            ),
            ElevatedButton(onPressed: _sendPrompt, child: const Text("Ask Gemini")),
            const SizedBox(height: 12),
            if (aiResponse != null) ...[
              const Text("Gemini Response:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(aiResponse!,
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
