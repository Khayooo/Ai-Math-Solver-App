// import 'package:ai_math_solver/dashboard/dashboard.dart';
// import 'package:flutter/material.dart';
//
// import '../services/database_services.dart';
// import '../utils/app_strings.dart';
// import '../utils/asset_paths.dart';
// import '../utils/colors_paths.dart';
// import 'detail_result_screen.dart';
//
// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});
//
//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }
//
// class _HistoryScreenState extends State<HistoryScreen> {
//   final DatabaseServices _databaseServices = DatabaseServices.instance;
//
//   final List<String> subjects = [
//     'All',
//     'Math',
//     'Biology',
//     'History',
//     'Physics',
//     'Chemistry',
//     'English',
//   ];
//
//   int selectedIndex = 0;
//   bool isLoading = true;
//   List<Map<String, dynamic>> allHistory = [];
//   List<Map<String, dynamic>> filteredHistory = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadHistory();
//   }
//
//   Future<void> _loadHistory() async {
//     setState(() => isLoading = true);
//     final data = await _databaseServices.getAllHistory();
//
//     setState(() {
//       allHistory = data;
//       filteredHistory = data;
//       isLoading = false;
//     });
//   }
//
//   void _filterBySubject(String subject) {
//     if (subject == AppStrings().all) {
//       filteredHistory = allHistory;
//     } else {
//       filteredHistory = allHistory
//           .where(
//             (item) =>
//                 (item['subject'] as String).toLowerCase() ==
//                 subject.toLowerCase(),
//           )
//           .toList();
//     }
//     setState(() {});
//   }
//
//   void _deleteAllHistory() async {
//     await _databaseServices.clearAllHistory();
//     await _loadHistory();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //  AppBar
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Dashboard()),
//             );
//           },
//           child: Image.asset(AssetPaths().back_button, scale: 3.0),
//         ),
//         title: Text(
//           AppStrings().chat_history,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         centerTitle: true,
//         actions: [
//           GestureDetector(
//             onTap: () async {
//               final confirm = await showDialog<bool>(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text("Clear All History?"),
//                   content: const Text("This action cannot be undone."),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       child: const Text("Cancel"),
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, true),
//                       child: const Text(
//                         "Delete All",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//
//               if (confirm == true) {
//                 _deleteAllHistory();
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: Image.asset(AssetPaths().delete_button, scale: 2.0),
//             ),
//           ),
//         ],
//       ),
//
//       //  Body
//       body: Column(
//         children: [
//           //  Subject Filter Bar
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: SizedBox(
//               height: 40,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: subjects.length,
//                 itemBuilder: (context, index) {
//                   final isSelected = index == selectedIndex;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                         _filterBySubject(subjects[index]);
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         subjects[index],
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: isSelected
//                               ? FontWeight.bold
//                               : FontWeight.normal,
//                           color: isSelected
//                               ? Colors.orange
//                               : Colors.grey.withOpacity(0.8),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Divider(height: 1, color: ColorsPaths().orange_color),
//
//           //  List of History
//           Expanded(
//             child: isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(color: Colors.orange),
//                   )
//                 : filteredHistory.isEmpty
//                 ? Center(
//                     child: Text(
//                       AppStrings().no_history_available,
//                       style: const TextStyle(color: Colors.grey, fontSize: 16),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: filteredHistory.length,
//                     itemBuilder: (context, index) {
//                       final item = filteredHistory[index];
//                       final subject = item['subject'] ?? 'Unknown';
//                       final prompt = item['prompt'] ?? '';
//                       // final date = item['date'] ?? '';
//
//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ListTile(
//                           //  Added Image Icon
//                           leading: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Image.asset(
//                                 AssetPaths().message_icon,
//                                 height: 28,
//                                 width: 28,
//                                 color: Colors.black,
//                               ),
//                               const SizedBox(width: 8),
//                             ],
//                           ),
//
//                           title: Text(
//                             subject,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                             ),
//                           ),
//                           subtitle: Text(
//                             prompt.length > 80
//                                 ? "${prompt.substring(0, 80)}..."
//                                 : prompt,
//                             style: const TextStyle(fontSize: 13),
//                           ),
//                           trailing: Container(
//                               height: 20,
//                               child: Image.asset(AssetPaths().forward_button_orange,)),
//
//
//                           onTap: () {
//                             // 🔹 TODO: Navigate to detailed result view
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) =>
//                                     DetailedResultScreen(historyId: item['id']),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:ai_math_solver/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/database_services.dart';
import '../utils/app_strings.dart';
import '../utils/asset_paths.dart';
import '../utils/colors_paths.dart';
import 'detail_result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DatabaseServices _databaseServices = DatabaseServices.instance;

  final List<String> subjects = [
    'All',
    'Math',
    'Biology',
    'History',
    'Physics',
    'Chemistry',
    'English',
  ];

  int selectedIndex = 0;
  bool isLoading = true;
  List<Map<String, dynamic>> allHistory = [];
  List<Map<String, dynamic>> filteredHistory = [];
  Map<String, List<Map<String, dynamic>>> groupedHistory = {};

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);
    final data = await _databaseServices.getAllHistory();

    setState(() {
      allHistory = data;
      filteredHistory = data;
      groupedHistory = _groupByDate(data);
      isLoading = false;
    });
  }

  /// 🧠 Group data by date (Today, Yesterday, or formatted date)
  Map<String, List<Map<String, dynamic>>> _groupByDate(List<Map<String, dynamic>> history) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    final now = DateTime.now();

    for (var item in history) {
      final dateStr = item['date'] ?? '';
      if (dateStr.isEmpty) continue;

      final date = DateTime.parse(dateStr);
      String label;

      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(date.year, date.month, date.day);

      if (itemDate == today) {
        label = 'Today';
      } else if (itemDate == yesterday) {
        label = 'Yesterday';
      } else {
        label = DateFormat('MMMM d, yyyy').format(date);
      }

      grouped.putIfAbsent(label, () => []);
      grouped[label]!.add(item);
    }

    return grouped;
  }

  void _filterBySubject(String subject) {
    List<Map<String, dynamic>> data;
    if (subject == AppStrings().all) {
      data = allHistory;
    } else {
      data = allHistory
          .where(
            (item) =>
        (item['subject'] as String).toLowerCase() ==
            subject.toLowerCase(),
      )
          .toList();
    }
    setState(() {
      filteredHistory = data;
      groupedHistory = _groupByDate(data);
    });
  }

  void _deleteAllHistory() async {
    await _databaseServices.clearAllHistory();
    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final groupKeys = groupedHistory.keys.toList();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
          child: Image.asset(AssetPaths().back_button, scale: 3.0),
        ),
        title: Text(
          AppStrings().chat_history,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Clear All History?"),
                  content: const Text("This action cannot be undone."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Delete All",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                _deleteAllHistory();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset(AssetPaths().delete_button, scale: 2.0),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // 📌 Subject Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        _filterBySubject(subjects[index]);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        subjects[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.orange
                              : Colors.grey.withOpacity(0.8),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Divider(height: 1, color: ColorsPaths().orange_color),

          // 📜 History List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                : groupedHistory.isEmpty
                ? Center(
              child: Text(
                AppStrings().no_history_available,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: groupKeys.length,
              itemBuilder: (context, groupIndex) {
                final group = groupKeys[groupIndex];
                final items = groupedHistory[group]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🏷️ Group Header (Today / Yesterday / Date)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(
                        group,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // 📄 List Items for this group
                    ...items.map((item) {
                      final subject = item['subject'] ?? 'Unknown';
                      final prompt = item['prompt'] ?? '';

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        color: ColorsPaths().white_light_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            AssetPaths().message_icon,
                            height: 28,
                            width: 28,
                            color: Colors.black,
                          ),
                          title: Text(
                            subject,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            prompt.length > 80
                                ? "${prompt.substring(0, 80)}..."
                                : prompt,
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: Image.asset(
                            AssetPaths().forward_button_orange,
                            height: 20,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailedResultScreen(historyId: item['id']),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

