import 'dart:io';
import 'package:flutter/material.dart';
import '../services/database_services.dart';
import '../utils/colors_paths.dart';
import '../utils/app_strings.dart';

class DetailedResultScreen extends StatefulWidget {
  final int historyId;

  const DetailedResultScreen({super.key, required this.historyId});

  @override
  State<DetailedResultScreen> createState() => _DetailedResultScreenState();
}

class _DetailedResultScreenState extends State<DetailedResultScreen> {
  Map<String, dynamic>? resultData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResultData();
  }

  Future<void> _loadResultData() async {
    final data = await DatabaseServices.instance.getHistoryById(widget.historyId);
    setState(() {
      resultData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (resultData == null) {
      return const Scaffold(
        body: Center(child: Text("No data found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detailed Result"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resultData!['imagePath'] != null &&
                File(resultData!['imagePath']).existsSync())
              Image.file(File(resultData!['imagePath']), height: 200),
            const SizedBox(height: 16),

            Text(
              resultData!['prompt'] ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Text(
              AppStrings().short_answer,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(resultData!['shortAnswer'] ?? '', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),

            Text(
              AppStrings().answer_in_detail,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(resultData!['detailedAnswer'] ?? '', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
