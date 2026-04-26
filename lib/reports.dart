import 'package:agno_project/add_associations.dart';
import 'package:agno_project/export_desktop.dart';
import 'package:agno_project/home.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:cloud_firestore/cloud_firestore.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() =>
      _ReportsState();
}


class _ReportsState extends State<Reports> {
  int totalAssociations = 0;
  int withLocations = 0;
  int assignedStaff = 0;
 int selectedYear = DateTime.now().year;

 Future<List<QueryDocumentSnapshot>> getAppointments(String iaName) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(iaName)
      .collection('monthlyTotals')
      .get();

  return snapshot.docs;
}


double extractValue(String text) {
  final match = RegExp(r'\d+').firstMatch(text);
  return match != null ? double.parse(match.group(0)!) : 0;
}

String extractType(String text) {
  if (text.contains('LS')) return 'LS';
  if (text.contains('LP')) return 'LP';
  if (text.contains('MV')) return 'MV';
  if (text.contains('MR')) return 'MR';
  return '';
}

bool isWithinWeek(DateTime date, DateTime start, DateTime end) {
  return date.isAfter(start.subtract(const Duration(days: 1))) &&
         date.isBefore(end.add(const Duration(days: 1)));
}
 
Future<Map<String, double>> computeTotals(String iaName) async {
  final docs = await getAppointments(iaName);

  double aulsRice = 0;

  DateTime weekStart = DateTime(2026, 1, 4);
  DateTime weekEnd = DateTime(2026, 1, 10);

  for (var doc in docs) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime date = (data['startTime'] as Timestamp).toDate();
    String subject = data['subject'] ?? '';

    if (!isWithinWeek(date, weekStart, weekEnd)) continue;

    double value = extractValue(subject);
    String type = extractType(subject);

    // 🔥 AULS = LS
    if (type == 'LS') {
      aulsRice += value;
    }
  }

  return {
    'AULS_RICE': aulsRice,
  };
}



 Future<void> exportToExcel() async {
  final workbook = xlsio.Workbook();
  final sheet = workbook.worksheets[0];

sheet.pageSetup.fitToPagesWide = 1;
// sheet.pageSetup.fitToPagesTall = false;

sheet.pageSetup.orientation = xlsio.ExcelPageOrientation.landscape;
sheet.pageSetup.paperSize = xlsio.ExcelPaperSize.paperLetter;

sheet.pageSetup.topMargin = 0.5;
sheet.pageSetup.bottomMargin = 0.5;
sheet.pageSetup.leftMargin = 0.3;
sheet.pageSetup.rightMargin = 0.3;



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

  // ===== CUSTOM HEADER STYLES =====

// 16 FONT
final header16 = workbook.styles.add('header16');
header16.bold = true;
header16.fontSize = 16;
header16.fontName = 'Arial Narrow';
header16.hAlign = xlsio.HAlignType.center;
header16.vAlign = xlsio.VAlignType.center;
header16.borders.all.lineStyle = xlsio.LineStyle.thin;

// 14 FONT
final header14 = workbook.styles.add('header14');
header14.bold = true;
header14.fontSize = 14;
header14.fontName = 'Arial Narrow';
header14.hAlign = xlsio.HAlignType.center;
header14.vAlign = xlsio.VAlignType.center;
header14.borders.all.lineStyle = xlsio.LineStyle.thin;

// 11 FONT
final header11 = workbook.styles.add('header11');
header11.bold = true;
header11.fontSize = 11;
header11.fontName = 'Arial Narrow';
header11.hAlign = xlsio.HAlignType.center;
header11.vAlign = xlsio.VAlignType.center;
header11.borders.all.lineStyle = xlsio.LineStyle.thin;

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
  int rowStart = 3;

  // NAME OF IA
 // NAME OF IA (A + B merged)

// NAME OF IA (A+B)
sheet.getRangeByIndex(rowStart, 1, rowStart + 2, 2).merge();
sheet.getRangeByIndex(rowStart, 1).setText('NAME OF IA');
sheet.getRangeByIndex(rowStart, 1).cellStyle = headerStyle;

// FUSA (column 3)
sheet.getRangeByIndex(rowStart, 3, rowStart + 2, 3).merge();
sheet.getRangeByIndex(rowStart, 3).setText('FUSA 2022 \n(ha.)');
sheet.getRangeByIndex(rowStart, 3).cellStyle = headerStyle;

// PROG AREA (shift to column 4–5)
sheet.getRangeByIndex(rowStart, 4, rowStart, 5).merge();
sheet.getRangeByIndex(rowStart, 4).setText('PROG. AREA');
sheet.getRangeByIndex(rowStart, 4).cellStyle = headerStyle;

sheet.getRangeByIndex(rowStart + 1, 4).setText('RICE');
sheet.getRangeByIndex(rowStart + 1, 5).setText('OC');

// START OF CROPPING (column 6)
sheet.getRangeByIndex(rowStart, 6, rowStart + 2, 6).merge();
sheet.getRangeByIndex(rowStart, 6).setText('START OF \nCROPPING');
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
  sheet.getRangeByIndex(rowStart, col, rowStart + 2, col).merge();
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
  // for (int r = rowStart; r <= rowStart + 11; r++) {
  //   for (int c = 1; c <= col + 1; c++) {
  //     sheet.getRangeByIndex(r, c).cellStyle = headerStyle;
  //   }
  // }

  for (int r = rowStart; r <= rowStart + 1; r++) {
  for (int c = 1; c <= col + 1; c++) {
    var cell = sheet.getRangeByIndex(r, c);

    String text = cell.text ?? '';

    if (text.contains('Submitted') || text.contains('Signed')) {
      cell.cellStyle = header11;
    } else if (text.contains('START') || text.contains('IRRIGATED')) {
      cell.cellStyle = header14;
    } else {
      cell.cellStyle = header16;
    }
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
// sheet.getRangeByIndex(1, 1).columnWidth = 6;   // numbering
// sheet.getRangeByIndex(1, 2).columnWidth = 28;  // IA names

//new to ha
sheet.getRangeByIndex(1, 1).columnWidth = 5.29;   // numbering
sheet.getRangeByIndex(1, 2).columnWidth = 35.29;  // IA names
sheet.getRangeByIndex(1, 3).columnWidth = 15.43;  // IA names

sheet.getRangeByIndex(1, 4).columnWidth = 11;  // IA names
sheet.getRangeByIndex(1, 5).columnWidth = 11;  // IA names

sheet.getRangeByIndex(1, 6).columnWidth = 13;   // numbering
sheet.getRangeByIndex(1, 7).columnWidth = 12.71;  // IA names
sheet.getRangeByIndex(1, 8).columnWidth = 11.43;  // IA names

sheet.getRangeByIndex(1, 9).columnWidth = 11.86;  // IA names
sheet.getRangeByIndex(1, 10).columnWidth = 12;  // IA names

sheet.getRangeByIndex(1, 11).columnWidth = 10.71;   // numbering

sheet.getRangeByIndex(1, 12).columnWidth = 13.29;  // IA names

sheet.getRangeByIndex(1, 13).columnWidth = 10.43;  // IA names
sheet.getRangeByIndex(1, 14).columnWidth = 11.29;  // IA names

sheet.getRangeByIndex(1, 15).columnWidth = 9;  // IA names


sheet.getRangeByIndex(1, 16).columnWidth = 9.71;   // numbering


sheet.getRangeByIndex(1, 17).columnWidth = 6.29;  // IA names
sheet.getRangeByIndex(1, 18).columnWidth = 12.14;  // IA names

sheet.getRangeByIndex(1, 19).columnWidth = 6.29;  // IA names
sheet.getRangeByIndex(1, 20).columnWidth = 13.86;  // IA names
sheet.getRangeByIndex(1, 21).columnWidth = 10;   // numbering

sheet.getRangeByIndex(1, 22).columnWidth = 10;  // IA names
sheet.getRangeByIndex(1, 23).columnWidth = 12.14; // IA names
sheet.getRangeByIndex(1, 24).columnWidth = 9;  // IA names

sheet.getRangeByIndex(1, 1).rowHeight = 30;  // IA names
sheet.getRangeByIndex(2, 1).rowHeight = 41;  // IA names
sheet.getRangeByIndex(3, 1).rowHeight = 20;  // IA names
sheet.getRangeByIndex(4, 1).rowHeight = 20;  // IA names
sheet.getRangeByIndex(5, 1).rowHeight = 24.5;  // IA names

sheet.getRangeByIndex(6, 1).rowHeight = 45;  // IA names
sheet.getRangeByIndex(7, 1).rowHeight = 45;  // IA names
sheet.getRangeByIndex(8, 1).rowHeight = 45;  // IA names
sheet.getRangeByIndex(9, 1).rowHeight = 45;  // IA names
sheet.getRangeByIndex(10, 1).rowHeight = 45;  // IA names


sheet.getRangeByIndex(11, 1).rowHeight = 45;  // IA names
sheet.getRangeByIndex(12, 1).rowHeight = 45;  // IA names
sheet.getRangeByIndex(13, 1).rowHeight = 45;  // IA names
sheet.getRangeByIndex(14, 1).rowHeight = 45;  // IA names

sheet.getRangeByIndex(15, 1).rowHeight = 66;  // IA names


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
  String iaName = iaList[i];

  // =========================
  // EXISTING CODE (KEEP THIS)
  // =========================
  sheet.getRangeByIndex(row, 1).setNumber(i + 1);
  sheet.getRangeByIndex(row, 1).cellStyle = numberStyle;

  sheet.getRangeByIndex(row, 2).setText(iaName);
  sheet.getRangeByIndex(row, 2).cellStyle = nameStyle;

  sheet.getRangeByIndex(row, 2).rowHeight =
      iaName.contains('\n') ? 28 : 20;

  // =========================
  // 🔥 NEW: FETCH FIREBASE DATA
  // =========================

 final doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(iaName)
    .collection('weeklyTotals')
    .doc('2026-01-04') // 🔥 your week start ID
    .get();

double aulsRice = 0;

if (doc.exists) {
  final data = doc.data()!;

  // 🔥 blue = AULS (LS)
  aulsRice = (data['blue'] ?? 0).toDouble();
}

  int aulsRiceCol = 7; // adjust based on your layout (G column)

  sheet.getRangeByIndex(row, aulsRiceCol).setNumber(aulsRice);
}

  // ===== SAVE =====
  final bytes = workbook.saveAsStream();
  workbook.dispose();

  downloadFile(bytes, "PFA_Formatted_trying_oop.xlsx");
}

  final List<Map<String, dynamic>> associations = [
    {
      "name": "Ilocos Sur - Unit 6",
      "desc": "Ilocos Sur irrigation association, Unit 6.",
      "location": "Region I",
      "staff": 1,
      "created": "Apr 10, 2026"
    },
    {
      "name": "La Union - Unit 1",
      "desc": "La Union irrigation association, Unit 1.",
      "location": "Region I",
      "staff": 0,
      "created": "Apr 10, 2026"
    },
  ];

  @override
  Widget build(BuildContext context) {
   return Scaffold(

appBar: AppBar(
    backgroundColor: const Color(0xFF0B3D0B),
    title: const Text(
      "Reports",
      style: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white), // menu icon color
  ),

  drawer: Drawer(
     backgroundColor: const Color(0xFF0B3D0B),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          
          child: Row(
            children: [
              Image.asset(
                'assets/images/asris_logo.png',
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 5),
              const Text(
                'NIA AgriCalendar\nADMIN PORTAL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
          ListTile(
     leading: const Icon(Icons.home, color: Colors.white, ),
          title: const Text('Home',  style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>  CalendarScreen(),
    ),
  );
          },
        ),
        ListTile(
            leading: const Icon(Icons.person_add_alt_sharp,  color: Colors.white,),
          title: const Text('Associations',  style: TextStyle(color: Colors.white)),
       onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => IrrigationAssociationsPage(),
    ),
  );
},
        ),

          ListTile(
          leading: const Icon(Icons.history_rounded, color: Colors.white,),
          title: const Text('Activity Logs',  style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),

         ListTile(
          leading: const Icon(Icons.analytics, color: Colors.white,),
          title: const Text('Reports',  style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
        ListTile(
  leading: const Icon(Icons.settings,  color: Colors.white,),
          title: const Text('Settings',  style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),




      ],
    ),
  ),

 

  
  backgroundColor: const Color(0xFF0B3D0B),

  // ✅ EVERYTHING GOES INSIDE BODY
  body: SafeArea(
    child: Column(
      children: [

        /// TOP ROW (optional — you can remove this now if you want cleaner UI)
       

        // MAIN CONTENT
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ADMIN PORTAL",
                            style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 5),
                        Text("Initials Reports",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  onPressed: exportToExcel,
  icon: const Icon(Icons.download, color: Colors.white),
  label: const Text(
    "Download PDF",
    style: TextStyle(color: Colors.white),
  ),
)
                  ]
                ),

                const SizedBox(height: 20),

                /// STATS
                Row(
                  children: [
                    _buildStatCard(" ", totalAssociations),
                    const SizedBox(width: 10),
                    _buildStatCard(" ", withLocations),
                    const SizedBox(width: 10),
                    _buildStatCard(" ", assignedStaff),
                  ],
                ),

                const SizedBox(height: 20),

                /// TABLE HEADER
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Expanded(child: Text(" ", style: TextStyle(color: Colors.white70))),
                      Expanded(child: Text(" ", style: TextStyle(color: Colors.white70))),
                      Expanded(child: Text(" ", style: TextStyle(color: Colors.white70))),
                      Expanded(child: Text(" ", style: TextStyle(color: Colors.white70))),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: associations.length,
                    itemBuilder: (context, index) {
                      final item = associations[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item["name"],
                                      style: const TextStyle(color: Colors.white)),
                                  Text(item["desc"],
                                      style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                            Expanded(child: Text(item["location"], style: const TextStyle(color: Colors.white))),
                            Expanded(child: Text(item["staff"].toString(), style: const TextStyle(color: Colors.white))),
                            Expanded(child: Text(item["created"], style: const TextStyle(color: Colors.white))),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);
  }

  /// STAT CARD WIDGET
  Widget _buildStatCard(String title, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}