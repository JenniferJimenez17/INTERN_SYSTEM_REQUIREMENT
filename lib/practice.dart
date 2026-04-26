import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'export_desktop.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  int selectedYear = DateTime.now().year;

 Future<void> exportToExcel() async {
  final workbook = xlsio.Workbook();
  final sheet = workbook.worksheets[0];

  // ===== STYLES =====
  final titleStyle = workbook.styles.add('title');
  titleStyle.bold = true;
  titleStyle.fontSize = 14;

  final subTitleStyle = workbook.styles.add('subtitle');
  subTitleStyle.bold = true;

  final headerStyle = workbook.styles.add('header');
  headerStyle.bold = true;
  headerStyle.hAlign = xlsio.HAlignType.center;
  headerStyle.vAlign = xlsio.VAlignType.center;
  headerStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

  final cellStyle = workbook.styles.add('cell');
  cellStyle.hAlign = xlsio.HAlignType.center;
  cellStyle.vAlign = xlsio.VAlignType.center;
  cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

  // ===== COLUMN WIDTHS =====
  for (int i = 1; i <= 25; i++) {
    sheet.getRangeByIndex(1, i).columnWidth = 12;
  }
  sheet.getRangeByIndex(1, 1).columnWidth = 25;

  // ===== TITLE =====
sheet.getRangeByName('A1:J1').merge();
sheet.getRangeByName('A1').setText('PROGRESS OF FARMING ACTIVITIES');
sheet.getRangeByName('A1').cellStyle = titleStyle;

// LEFT SUBTITLE
sheet.getRangeByName('A2:J2').merge();
sheet.getRangeByName('A2').setText('Cropping Season: DRYCROP 2026');
sheet.getRangeByName('A2').cellStyle = subTitleStyle;


sheet.getRangeByName('K1:Z1').merge();
sheet.getRangeByName('K1').setText('AGNO-SINOCALAN RIS');
sheet.getRangeByName('K1').cellStyle = titleStyle;
sheet.getRangeByName('K1').cellStyle.hAlign = xlsio.HAlignType.left;

sheet.getRangeByName('K2:Z2').merge();
sheet.getRangeByName('K2').setText('As of: JAN09');
sheet.getRangeByName('K2').cellStyle = subTitleStyle;
sheet.getRangeByName('K2').cellStyle.hAlign = xlsio.HAlignType.left;

  // ===== MAIN HEADERS =====
  int rowStart = 4;

  // NAME OF IA
 // NAME OF IA (A + B merged)

// NAME OF IA (A+B)
sheet.getRangeByIndex(rowStart, 1, rowStart + 1, 2).merge();
sheet.getRangeByIndex(rowStart, 1).setText('NAME OF IA');
sheet.getRangeByIndex(rowStart, 1).cellStyle = headerStyle;

// FUSA (column 3)
sheet.getRangeByIndex(rowStart, 3, rowStart + 1, 3).merge();
sheet.getRangeByIndex(rowStart, 3).setText('FUSA 2022 (ha.)');
sheet.getRangeByIndex(rowStart, 3).cellStyle = headerStyle;

// PROG AREA (shift to column 4–5)
sheet.getRangeByIndex(rowStart, 4, rowStart, 5).merge();
sheet.getRangeByIndex(rowStart, 4).setText('PROG. AREA');
sheet.getRangeByIndex(rowStart, 4).cellStyle = headerStyle;

sheet.getRangeByIndex(rowStart + 1, 4).setText('RICE');
sheet.getRangeByIndex(rowStart + 1, 5).setText('OC');

// START OF CROPPING (column 6)
sheet.getRangeByIndex(rowStart, 6, rowStart + 1, 6).merge();
sheet.getRangeByIndex(rowStart, 6).setText('START OF CROPPING');
sheet.getRangeByIndex(rowStart, 6).cellStyle = headerStyle;

  // FUNCTION for grouped columns
int col = 7;

// ===== AULS =====
// ===== AULS =====
sheet.getRangeByIndex(rowStart, col).setText('AULS');
sheet.getRangeByIndex(rowStart, col).cellStyle = headerStyle;

sheet.getRangeByIndex(rowStart + 1, col, rowStart + 1, col + 1).merge();
sheet.getRangeByIndex(rowStart + 1, col).setText('RICE');
sheet.getRangeByIndex(rowStart + 1, col).cellStyle = headerStyle;

col++; // move to next column

// ===== AULP (MERGED H + I) =====
sheet.getRangeByIndex(rowStart, col, rowStart, col + 1).merge();
sheet.getRangeByIndex(rowStart, col).setText('AULP');
sheet.getRangeByIndex(rowStart, col).cellStyle = headerStyle;

// 🔥 ONLY OC, but stretched across 2 columns
// sheet.getRangeByIndex(rowStart + 1, col, rowStart + 1, col + 1).merge();
sheet.getRangeByIndex(rowStart + 1, col + 1).setText('OC');
sheet.getRangeByIndex(rowStart + 1, col + 1).cellStyle = headerStyle;

col += 2; // IMPORTANT: shift everything to the right







// ===== REMAINING GROUPS (NORMAL: RICE + OC) =====
List<String> groups = [
  'ACMV',
  'ACMR',
  'TI',
  'AH',
  'PLANTED'
];

for (var g in groups) {
  sheet.getRangeByIndex(rowStart, col, rowStart, col + 1).merge();
  sheet.getRangeByIndex(rowStart, col).setText(g);
  sheet.getRangeByIndex(rowStart, col).cellStyle = headerStyle;

  sheet.getRangeByIndex(rowStart + 1, col).setText('RICE');
  sheet.getRangeByIndex(rowStart + 1, col + 1).setText('OC');

  col += 2;
}

  // IRRIGATED
  sheet.getRangeByIndex(rowStart, col, rowStart + 1, col).merge();
  sheet.getRangeByIndex(rowStart, col).setText('IRRIGATED');
  sheet.getRangeByIndex(rowStart, col).cellStyle = headerStyle;
  col++;

  // LIPA
  sheet.getRangeByIndex(rowStart, col, rowStart, col + 1).merge();
  sheet.getRangeByIndex(rowStart, col).setText('LIPA (ha.)');

  sheet.getRangeByIndex(rowStart + 1, col).setText('Submitted');
  sheet.getRangeByIndex(rowStart + 1, col + 1).setText('Signed');

  col += 2;

  // AVERAGE YIELD
  sheet.getRangeByIndex(rowStart, col, rowStart, col + 1).merge();
  sheet.getRangeByIndex(rowStart, col).setText('AVERAGE YIELD');

  sheet.getRangeByIndex(rowStart + 1, col).setText('RICE');
  sheet.getRangeByIndex(rowStart + 1, col + 1).setText('OC');

  // Apply style to all headers
  //DITO YUNG PAG MAY GUSTO KA INAHIN NA ROW
  for (int r = rowStart; r <= rowStart + 11; r++) {
    for (int c = 1; c <= col + 1; c++) {
      sheet.getRangeByIndex(r, c).cellStyle = headerStyle;
    }
  }

 List<String> iaList = [
  'SANV-DUMAC',
  'NARAGSAK DMD',
  'GREAT DOMANPOT\nGRAIN ACRES',
  'DUR-AS CARNORTE',
  'UNITED PIASURNOR',
  'PIAZ VILLASIS',
  'CARAMUTAN VILLASIS',
  'DOMANPOT SOLID',
  'ABANTE BACTAD',
  'SULONG TIMACO',
];

// Column widths (match screenshot)
sheet.getRangeByIndex(1, 1).columnWidth = 6;   // numbering
sheet.getRangeByIndex(1, 2).columnWidth = 28;  // IA names

// Header
sheet.getRangeByIndex(4, 2).cellStyle.bold = true;
sheet.getRangeByIndex(4, 2).cellStyle.hAlign = xlsio.HAlignType.center;
sheet.getRangeByIndex(4, 2).cellStyle.borders.all.lineStyle =
    xlsio.LineStyle.thin;

// Styles
final numberStyle = workbook.styles.add('numberStyle');
numberStyle.hAlign = xlsio.HAlignType.center;
numberStyle.vAlign = xlsio.VAlignType.center;
numberStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

final nameStyle = workbook.styles.add('nameStyle');
nameStyle.hAlign = xlsio.HAlignType.left;
nameStyle.vAlign = xlsio.VAlignType.center;
nameStyle.wrapText = true;
nameStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

// Data rows
int startRow = 6;

for (int i = 0; i < iaList.length; i++) {
  int row = startRow + i;

  // numbering
  sheet.getRangeByIndex(row, 1).setNumber(i + 1);
  sheet.getRangeByIndex(row, 1).cellStyle = numberStyle;

  // IA name
  sheet.getRangeByIndex(row, 2).setText(iaList[i]);
  sheet.getRangeByIndex(row, 2).cellStyle = nameStyle;

  // Adjust height for multi-line
  if (iaList[i].contains('\n')) {
    sheet.getRangeByIndex(row, 2).rowHeight = 28;
  } else {
    sheet.getRangeByIndex(row, 2).rowHeight = 20;
  }
}

  // ===== SAVE =====
  final bytes = workbook.saveAsStream();
  workbook.dispose();

  downloadFile(bytes, "PFA_Formatted_trying_oop.xlsx");
}
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: exportToExcel,
          child: const Text('Download Excel'),
        ),
      ),
    );
  }
}

// Generate weeks dynamically
List<String> generateWeeks(int year) {
  List<String> weeks = [];

  DateTime start = DateTime(year, 1, 1);
  DateTime end = DateTime(year, 12, 31);

  while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
    DateTime weekEnd = start.add(const Duration(days: 6));

    weeks.add("${start.day}-${weekEnd.day}");

    start = start.add(const Duration(days: 7));
  }

  return weeks;
}