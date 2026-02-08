import 'package:brainwave/view/admin/upload_written_questions_view.dart';
import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'topbar.dart'; // ✅ Check if this path is correct for you
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
  // 1. State Variable
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Define 'pages' INSIDE build() so it can access 'setState'
    final List<Widget> pages = [
      DashboardView(
        onQuickAction: (index) {
          // This allows the Dashboard to switch the tab
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const UploadQuestionsView(),
      const EvaluateSheetsView(),
      const QuestionManagementView(),
      const UploadWrittenQuestionsView(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Row(
        children: [
          // 2. Sidebar
          Sidebar(
            currentIndex: _currentIndex,
            onChanged: (i) => setState(() => _currentIndex = i),
          ),

          // 3. Main Content
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(
                  // Display the page corresponding to the current index
                  child: pages[_currentIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
