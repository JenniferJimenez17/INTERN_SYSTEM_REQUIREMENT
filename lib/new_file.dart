import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExcelSizeDemo extends StatefulWidget {
  const ExcelSizeDemo({super.key});

  @override
  State<ExcelSizeDemo> createState() => _ExcelSizeDemoState();
}

class _ExcelSizeDemoState extends State<ExcelSizeDemo> {

  Future<void> exportExcel() async {
    final workbook = Workbook();
    final sheet = workbook.worksheets[0];

    // =========================
    // ✅ SIZE SETTINGS ONLY
    // =========================

    // Column widths
sheet.getRangeByName('A1').columnWidth = 30;
sheet.getRangeByName('B1').columnWidth = 20;
sheet.getRangeByName('C1').columnWidth = 25;
    // Row heights
sheet.getRangeByName('A1').rowHeight = 40;

for (int i = 2; i <= 10; i++) {
  sheet.getRangeByName('A$i').rowHeight = 25;
}

    // (Optional) sample data just to see spacing
    sheet.getRangeByName('A1').setText('Column A');
    sheet.getRangeByName('B1').setText('Column B');
    sheet.getRangeByName('C1').setText('Column C');

    sheet.getRangeByName('A2').setText('Data 1');
    sheet.getRangeByName('B2').setText('Data 2');
    sheet.getRangeByName('C2').setText('Data 3');

    // =========================
    // SAVE FILE
    // =========================
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/excel_size_demo.xlsx');
    await file.writeAsBytes(bytes, flush: true);

    debugPrint('Excel saved at: ${file.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Excel Size Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: exportExcel,
          child: const Text('Export Excel'),
        ),
      ),
    );
  }
}