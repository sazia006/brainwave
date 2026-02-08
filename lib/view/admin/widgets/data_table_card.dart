import 'package:flutter/material.dart';

class DataTableCard extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> rows;

  const DataTableCard({super.key, required this.headers, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(.05)),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 30,
          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          columns: headers.map((h) => DataColumn(label: Text(h))).toList(),
          rows: rows
              .map(
                (cells) =>
                    DataRow(cells: cells.map((c) => DataCell(c)).toList()),
              )
              .toList(),
        ),
      ),
    );
  }
}
