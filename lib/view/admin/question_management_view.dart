import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ✅ Change to StatefulWidget
class QuestionManagementView extends StatefulWidget {
  const QuestionManagementView({super.key});

  @override
  State<QuestionManagementView> createState() => _QuestionManagementViewState();
}

class _QuestionManagementViewState extends State<QuestionManagementView> {
  // ✅ This key controls the StreamBuilder. Changing it forces a reload.
  Key _streamKey = UniqueKey();

  void _refreshData() {
    setState(() {
      _streamKey = UniqueKey(); // 🔄 Generates a new key to force rebuild
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Refreshing data..."),
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Question Database",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              // ✅ FUNCTIONAL REFRESH BUTTON
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: "Refresh Table",
                onPressed: _refreshData,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: StreamBuilder<QuerySnapshot>(
                key:
                    _streamKey, // ✅ Key attaches the stream to the refresh logic
                stream: FirebaseFirestore.instance
                    .collection('questions')
                    .orderBy('createdAt', descending: true)
                    .limit(50)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Shows loading spinner when refreshing
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text("No data available"));
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(child: Text("No questions found."));
                  }

                  // ... (Rest of your DataTable code remains the same) ...
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 24,
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey.shade100,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              "Question",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Options",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Correct Answer",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Explanation",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Actions",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final List<dynamic> options = data['options'] ?? [];

                          return DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    data['question'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    options.join(", "),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data['correctAnswer'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    data['explanation'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () =>
                                          _showEditDialog(context, doc),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          _deleteQuestion(context, doc.id),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ... (Keep your existing _deleteQuestion and _showEditDialog methods here) ...
  // Paste the previous methods for _deleteQuestion and _showEditDialog below

  void _deleteQuestion(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Question"),
        content: const Text("Are you sure? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('questions')
                  .doc(docId)
                  .delete();
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final _formKey = GlobalKey<FormState>();

    final questionCtrl = TextEditingController(text: data['question']);
    final answerCtrl = TextEditingController(text: data['correctAnswer']);
    final explanationCtrl = TextEditingController(text: data['explanation']);

    List<dynamic> currentOptions = data['options'] ?? ["", "", "", ""];
    final optACtrl = TextEditingController(
      text: currentOptions.length > 0 ? currentOptions[0] : "",
    );
    final optBCtrl = TextEditingController(
      text: currentOptions.length > 1 ? currentOptions[1] : "",
    );
    final optCCtrl = TextEditingController(
      text: currentOptions.length > 2 ? currentOptions[2] : "",
    );
    final optDCtrl = TextEditingController(
      text: currentOptions.length > 3 ? currentOptions[3] : "",
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Question"),
        content: Container(
          width: 500,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: questionCtrl,
                    decoration: const InputDecoration(
                      labelText: "Question",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _optionField(optACtrl, "Option A")),
                      const SizedBox(width: 10),
                      Expanded(child: _optionField(optBCtrl, "Option B")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _optionField(optCCtrl, "Option C")),
                      const SizedBox(width: 10),
                      Expanded(child: _optionField(optDCtrl, "Option D")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: answerCtrl,
                    decoration: const InputDecoration(
                      labelText: "Correct Answer",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: explanationCtrl,
                    decoration: const InputDecoration(
                      labelText: "Explanation",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await FirebaseFirestore.instance
                    .collection('questions')
                    .doc(doc.id)
                    .update({
                      'question': questionCtrl.text.trim(),
                      'options': [
                        optACtrl.text.trim(),
                        optBCtrl.text.trim(),
                        optCCtrl.text.trim(),
                        optDCtrl.text.trim(),
                      ],
                      'correctAnswer': answerCtrl.text.trim(),
                      'explanation': explanationCtrl.text.trim(),
                    });
                if (context.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  Widget _optionField(TextEditingController ctrl, String label) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }
}
