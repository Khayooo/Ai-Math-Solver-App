import 'dart:io';
import 'package:ai_math_solver/custom_widget/loader_widget.dart';
import 'package:ai_math_solver/utils/app_strings.dart';
import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../history/history_screen.dart';
import '../scan screen/scan_screen.dart';
import '../services/database_services.dart';
import '../utils/asset_paths.dart';

class ResultScreen extends StatefulWidget {
  final File image;
  final String prompt;
  final String shortAnswer;
  final String detailedAnswer;
  final String selectedSubject;
  final File imageFile;

  const ResultScreen({
    super.key,
    required this.image,
    required this.prompt,
    required this.shortAnswer,
    required this.detailedAnswer,
    required this.selectedSubject,
    required this.imageFile,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool showFullAnswer = false;
  String shortAnswer = "";
  String detailedAnswer = "";
  late String prompt;

  var isLoading = false;

  @override
  void initState() {
    super.initState();

    // ✅ Proper subject-based prompt selection
    final subject = widget.selectedSubject.trim().toLowerCase();

    if (subject == 'math') {
      prompt = "Solve the above Math problem.";
    } else if (subject == 'physics') {
      prompt = "Solve the above Physics problem.";
    } else if (subject == 'chemistry') {
      prompt = "Solve the above Chemistry problem.";
    } else if (subject == 'biology') {
      prompt = "Solve the above Biology question.";
    } else if (subject == 'english') {
      prompt = "Solve the above English question.";
    } else if (subject == 'geography') {
      prompt = "Solve the above Geography question.";
    } else {
      prompt = "Analyze and answer the above problem.";
    }

    // ✅ Combine recognized question text with subject-based prompt
    prompt = "${widget.prompt}\n\n$prompt";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isLoading = true);
      _processImage();
    });
  }

  Future<void> _processImage() async {
    try {
      final apiKey = "AIzaSyB7NToCpz_ckbWPpQ01ApEEQGHRy-EyMR0";
      final model = GenerativeModel(model: "gemini-2.5-flash", apiKey: apiKey);

      final bytes = await widget.imageFile.readAsBytes();
      final content = [
        Content.multi([TextPart(prompt), DataPart('image/png', bytes)]),
      ];

      final response = await model.generateContent(content);
      final rawText = response.text ?? "No response received.";

      // ✅ Clean unwanted markdown formatting
      final cleanedText = rawText
          .replaceAll(RegExp(r'\*{1,3}'), '')
          .replaceAll(RegExp(r'_'), '')
          .replaceAll(RegExp(r'`'), '')
          .replaceAll(RegExp(r'\n{3,}'), '\n\n')
          .trim();

      // ✅ Split between short and detailed answer
      final lines =
      cleanedText.split('\n').where((line) => line.trim().isNotEmpty).toList();

      String shortAns = "";
      String detailAns = "";

      if (lines.isNotEmpty) {
        final answerIndex = lines.indexWhere((l) =>
        l.toLowerCase().startsWith("answer") ||
            (l.contains("=") && l.length < 60) ||
            RegExp(r'\b(result|solution)\b', caseSensitive: false).hasMatch(l));

        if (answerIndex != -1) {
          shortAns = lines[answerIndex]
              .replaceAll(RegExp(r'^(Answer|Solution|Result)[:\-\s]*',
              caseSensitive: false), '')
              .trim();
          detailAns = lines.join('\n').trim();
        } else {
          shortAns = lines.first.trim();
          detailAns = lines.skip(1).join('\n').trim();
        }
      } else {
        shortAns = cleanedText;
        detailAns = cleanedText;
      }

      setState(() {
        isLoading = false;
        shortAnswer = shortAns;
        detailedAnswer = detailAns;
      });

      // ✅ Save to database with the correct prompt and subject
      final id = await DatabaseServices.instance.insertHistory(
        subject: widget.selectedSubject,
        prompt: widget.prompt, // original recognized text
        shortAnswer: shortAns,
        detailedAnswer: detailAns,
        imagePath: widget.imageFile.path,
      );

      debugPrint("✅ History saved successfully with ID: $id");
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("❌ Image Processing Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ScanScreen(selectedSubject: widget.selectedSubject),
                    ),
                  );
                },
                child: Image.asset(AssetPaths().back_button, scale: 3.0),
              ),
              title: const Text(
                "Result Screen",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    AssetPaths().result_screen_history_button,
                    scale: 2.0,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Image.asset(AssetPaths().dotes_button, scale: 2.0),
                  color: ColorsPaths().white_color,
                  onSelected: (value) {
                    if (value == "export") {
                      // export logic
                    } else if (value == "delete") {
                      _showDeleteDialog(context);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "export",
                      child: Row(
                        children: [
                          Image.asset(AssetPaths().export_button, scale: 2.0),
                          const SizedBox(width: 10),
                          const Text("Export"),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "delete",
                      child: Row(
                        children: [
                          Image.asset(AssetPaths().delete_button, scale: 2.0),
                          const SizedBox(width: 10),
                          Text(
                            "Delete",
                            style: TextStyle(color: ColorsPaths().red_color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildImageSection(),
                  _buildShortAnswer(),
                  _buildDetailedAnswer(),
                ],
              ),
            ),
          ),
          LoaderWidget(isLoading: isLoading),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorsPaths().white_light_color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(widget.image, height: 200, fit: BoxFit.fitHeight),
          const SizedBox(height: 10),
          Text(
            " ${widget.prompt}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildShortAnswer() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsPaths().white_light_color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings().short_answer,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(shortAnswer, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDetailedAnswer() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsPaths().white_light_color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings().answer_in_detail,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (!showFullAnswer)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detailedAnswer.length > 200
                      ? "${detailedAnswer.substring(0, 200)}..."
                      : detailedAnswer,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => showFullAnswer = true),
                    child: Text(
                      AppStrings().view_full_solution,
                      style: TextStyle(
                        color: ColorsPaths().orange_color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Text(detailedAnswer, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure want to delete this chat",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorsPaths().light_orange_color),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: ColorsPaths().orange_color,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorsPaths().gradient_color_light,
                            ColorsPaths().gradient_color_light,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 12),
                      child: const Text(
                        "Yes Delete",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
