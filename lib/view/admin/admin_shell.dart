import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'topbar.dart';
import 'dashboard_view.dart';
import 'upload_questions_view.dart';
import 'question_management_view.dart';
import 'evaluate_sheets_view.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int currentIndex = 0;

  final pages = const [
    DashboardView(),
    UploadQuestionsView(),
    EvaluateSheetsView(),
    QuestionManagementView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Row(
        children: [
          Sidebar(
            currentIndex: currentIndex,
            onChanged: (i) => setState(() => currentIndex = i),
          ),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(child: pages[currentIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
