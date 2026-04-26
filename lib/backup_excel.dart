import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
// import 'dart:html' as html;

import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'export_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
int selectedYear = DateTime.now().year;

bool isLeapYear(int year) {
  return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Home Page')),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              
 

    SizedBox(
  width: 200,
  
  child: DropdownMenu<int>(
  initialSelection: selectedYear,
  onSelected: (value) {
    setState(() {
      selectedYear = value!;
    });
  },


  label: const Text('Select Year'),
  dropdownMenuEntries: List.generate(
    DateTime.now().year - 2020 + 1,
    (index) {
      final year = 2020 + index;
      return DropdownMenuEntry<int>(
        value: year,
        label: year.toString(),
      );
    },
  ),
),

),

      const SizedBox(height: 20),
               Expanded(
              child: MyDataGrid(year: selectedYear)),
         ],
        
          ),
        ),
      );
  }
}

// Step 1: Create a simple data model
class RowData {
  RowData(this.ia, this.january, this.february, this.march, 
  this.april, this.may, this.june, this.july, this.august, 
  this.september, this.october, this.november, this.december, this.jan);

  final String ia;
  final String january;
  final String february;
  final String march;
  final String april;
  final String may; //1
  final String june; //2
  final String july; //3
  final String august;//4
  final String september; //5
  final String october; //6
  final String november; //7
  final String december; //8
  final String jan;
}

// Step 2: Create the DataGridSource
class RowDataSource extends DataGridSource {
  RowDataSource(List<RowData> rows) {
    dataGridRows = rows
        .map<DataGridRow>((row) => DataGridRow(cells: [
              DataGridCell(columnName: 'IA', value: row.ia),
              DataGridCell(columnName: 'JanWeek1', value: row.january),
              DataGridCell(columnName: 'JanWeek2', value: row.january), 
                DataGridCell(columnName:'JanWeek3', value: row.january),
              DataGridCell(columnName: 'JanWeek4', value: row.january),


              DataGridCell(columnName: 'FebWeek1', value: row.february),
              DataGridCell(columnName: 'FebWeek2', value: row.february), 
              DataGridCell(columnName: 'FebWeek3', value: row.february),
              DataGridCell(columnName: 'FebWeek4', value: row.february),

              DataGridCell(columnName: 'MarchWeek1', value: row.march),
              DataGridCell(columnName: 'MarchWeek2', value: row.march),
              DataGridCell(columnName: 'MarchWeek3', value: row.march),
              DataGridCell(columnName: 'MarchWeek4', value: row.march), 

              DataGridCell(columnName: 'AprilWeek1', value: row.april), //mark this mf
              DataGridCell(columnName: 'AprilWeek2', value: row.april),
              DataGridCell(columnName: 'AprilWeek3', value: row.april), //mark this mf
              DataGridCell(columnName: 'AprilWeek4', value: row.april),
              DataGridCell(columnName: 'AprilWeek5', value: row.april),

              DataGridCell(columnName: 'MayWeek1', value: row.may), 
              DataGridCell(columnName: 'MayWeek2', value: row.may), 
              DataGridCell(columnName: 'MayWeek3', value: row.may), 
              DataGridCell(columnName: 'MayWeek4', value: row.may),
       


              DataGridCell(columnName: 'JuneWeek1', value: row.june),
              DataGridCell(columnName: 'JuneWeek2', value: row.june),
              DataGridCell(columnName: 'JuneWeek3', value: row.june),
              DataGridCell(columnName: 'JuneWeek4', value: row.june),


               DataGridCell(columnName: 'JulyWeek1', value: row.july),
               DataGridCell(columnName: 'JulyWeek2', value: row.july),
               DataGridCell(columnName: 'JulyWeek3', value: row.july),
               DataGridCell(columnName: 'JulyWeek4', value: row.july),
               DataGridCell(columnName: 'JulyWeek5', value: row.july),


              DataGridCell(columnName: 'AugustWeek1', value: row.august),
              DataGridCell(columnName: 'AugustWeek2', value: row.august),
              DataGridCell(columnName: 'AugustWeek3', value: row.august),
              DataGridCell(columnName: 'AugustWeek4', value: row.august),


               DataGridCell(columnName: 'SeptemberWeek1', value: row.september),
               DataGridCell(columnName: 'SeptemberWeek2', value: row.september),
               DataGridCell(columnName: 'SeptemberWeek3', value: row.september),
               DataGridCell(columnName: 'SeptemberWeek4', value: row.september),
               DataGridCell(columnName: 'SeptemberWeek5', value: row.september),


               DataGridCell(columnName: 'OctoberWeek1', value: row.october),
               DataGridCell(columnName: 'OctoberWeek2', value: row.october),
               DataGridCell(columnName: 'OctoberWeek3', value: row.october),
               DataGridCell(columnName: 'OctoberWeek4', value: row.october),

              DataGridCell(columnName: 'NovemberWeek1', value: row.november),
              DataGridCell(columnName: 'NovemberWeek2', value: row.november),
              DataGridCell(columnName: 'NovemberWeek3', value: row.november),
              DataGridCell(columnName: 'NovemberWeek4', value: row.november),


              DataGridCell(columnName: 'DecemberWeek1', value: row.december),
              DataGridCell(columnName: 'DecemberWeek2', value: row.december),
              DataGridCell(columnName: 'DecemberWeek3', value: row.december),
              DataGridCell(columnName: 'DecemberWeek4', value: row.december),
              DataGridCell(columnName: 'DecemberWeek5', value: row.december),

              DataGridCell(columnName: 'JanuaryWeek1', value: row.jan),
            ]))


        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

@override
DataGridRowAdapter buildRow(DataGridRow row) {
  return DataGridRowAdapter(
    cells: row.getCells().map<Widget>((cell) {
      return InkWell(
        onTap: () {
          final controller =
              TextEditingController(text: cell.value?.toString() ?? '');

          showDialog(
            context: navigatorKey.currentContext!, // important
            builder: (context) {
              return AlertDialog(
                title: Text(cell.columnName),
                content: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter value',
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                 ElevatedButton(
  onPressed: () {
    final newValue = controller.text;

    final rowIndex = dataGridRows.indexOf(row);
    final cellIndex = row.getCells().indexOf(cell);

    dataGridRows[rowIndex].getCells()[cellIndex] =
        DataGridCell<String>(
          columnName: cell.columnName,
          value: newValue,
        );

    notifyListeners(); // VERY IMPORTANT

    Navigator.pop(context);
  },
  child: const Text("OK"),
),

                ],
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(cell.value.toString()),
        ),
      );
    }).toList(),
  );
}


}

// Step 3: Build the DataGrid Widget
class MyDataGrid extends StatefulWidget {
   final int year;


  const MyDataGrid({super.key, required this.year});

  @override
  State<MyDataGrid> createState() => _MyDataGridState();
}

class _MyDataGridState extends State<MyDataGrid> {
  final GlobalKey<SfDataGridState> _dataGridKey = GlobalKey();
  
//yung pangalawa sa chatgpt malapit na
Future<void> exportToExcel() async {
  final workbook = _dataGridKey.currentState!.exportToExcelWorkbook();
  final sheet = workbook.worksheets[0];

  final weeks = generateWeeks(widget.year); // get dynamic weeks

  // List of month column start-end indices (B=2, C=3,...)
  final monthColumns = {
    'January': [2, 5],    // B:E
    'February': [6, 9],   // F:I
    'March': [10, 13],    // J:M
    'April': [14, 18],    // N:R
    'May': [19, 22],      // S:V
    'June': [23, 26],     // W:Z
    'July': [27, 31],     // AA:AE
    'August': [32, 35],   // AF:AI
    'September': [36, 40],// AJ:AN
    'October': [41, 44],  // AO:AR
    'November': [45, 48], // AS:AV
    'December': [49, 53], // AW:BA
  };

  // Merge and label months dynamically
  int weekIndex = 0;
  final style = workbook.styles.add('monthStyle');
  style.bold = true;
  style.hAlign = xlsio.HAlignType.center;
  style.vAlign = xlsio.VAlignType.center;

  monthColumns.forEach((month, range) {
    final startCol = range[0];
    final endCol = range[1];

    sheet.getRangeByIndex(1, startCol, 1, endCol).merge();
    sheet.getRangeByIndex(1, startCol).setText(month);
    sheet.getRangeByIndex(1, startCol).cellStyle = style;

    // Set week numbers dynamically in row 2
    for (int col = startCol; col <= endCol; col++) {
      if (weekIndex < weeks.length) {
        sheet.getRangeByIndex(2, col).setText(weeks[weekIndex]);
        weekIndex++;
      }
    }
  });

  final bytes = workbook.saveAsStream();
  workbook.dispose();

 downloadFile(bytes, "DataGrid_${widget.year}.xlsx");

}


  @override
  Widget build(BuildContext context) {
    final weeks = generateWeeks(widget.year);

    // Step 3a: Create some sample data
    final List<RowData> rows = [
      RowData('SANV-DUMAC', '', '', '', '', '', '', '', '', '', '', '', '',''),
       RowData('SANV-DUMAC', '', '', '', '', '', '', '', '', '', '', '', '',''),
         RowData('SANV-DUMAC', '', '', '', '', '', '', '', '', '', '', '', '',''),
      RowData('NARAGSAK DMD', '', '', '', '', '', '', '', '', '', '', '', '', ''),
      RowData('GREAT DOMANPOT', '', '', '', '', '', '', '', '', '', '', '', '', ''),

    ];

    final RowDataSource rowDataSource = RowDataSource(rows);

return Column( 
  children: [

    
    ElevatedButton(
      onPressed: exportToExcel,
      child: const Text("Export to Excel"),
    ),
    // Step 3b: Create the DataGridSource


    // Step 3c: Build the SfDataGrid
     Expanded(
      child: SfDataGrid(
        key: _dataGridKey,
        source: rowDataSource,
        
        stackedHeaderRows: [
        StackedHeaderRow(
      cells: [
      StackedHeaderCell(
        columnNames: ['JanWeek1', 'JanWeek2', 'JanWeek3', 'JanWeek4'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'January',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      
        // February group
      StackedHeaderCell(
        columnNames: ['FebWeek1', 'FebWeek2', 'FebWeek3', 'FebWeek4'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'February',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      
        // march group
      StackedHeaderCell(
        columnNames: ['MarchWeek1', 'MarchWeek2', 'MarchWeek3', 'MarchWeek4'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'March',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      //april
        StackedHeaderCell(
        columnNames: ['AprilWeek1', 'AprilWeek2', 'AprilWeek3', 'AprilWeek4', 'AprilWeek5'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'April',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      //may
        StackedHeaderCell(
        columnNames: ['MayWeek1', 'MayWeek2', 'MayWeek3', 'MayWeek4',],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'May',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      
      //june
        StackedHeaderCell(
        columnNames: ['JuneWeek1', 'JuneWeek2','JuneWeek3', 'JuneWeek4',],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'June',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      
      //july
        StackedHeaderCell(
        columnNames: ['JulyWeek1', 'JulyWeek2','JulyWeek3', 'JulyWeek4','JulyWeek5'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'July',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      
      
      //aug
        StackedHeaderCell(
        columnNames: ['AugustWeek1', 'AugustWeek2', 'AugustWeek3', 'AugustWeek4'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'August',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      
      //sept
        
        StackedHeaderCell(
        columnNames: ['SeptemberWeek1', 'SeptemberWeek2', 'SeptemberWeek3', 'SeptemberWeek4', 'SeptemberWeek5'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'September',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      
      
      //oct
        StackedHeaderCell(
        columnNames: ['OctoberWeek1', 'OctoberWeek2', 'OctoberWeek3', 'OctoberWeek4'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'October',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      //nov
        StackedHeaderCell(
        columnNames: ['NovemberWeek1', 'NovemberWeek2', 'NovemberWeek3', 'NovemberWeek4' ],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'November',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      //dec
        StackedHeaderCell(
        columnNames: ['DecemberWeek1', 'DecemberWeek2', 'DecemberWeek3', 'DecemberWeek4', 'DecemberWeek5'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'December',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
        StackedHeaderCell(
        columnNames: ['JanuaryWeek1'],
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'January',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
      
      
      
      
        ]
        )
      ],
      
      
          gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columns: <GridColumn>[
        
            GridColumn(
            columnName: 'IA',
            label: const Center(
              child: Text('IA', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
      //        GridColumn(
      //   columnName: 'January',
      //   width: 150, // 👈 Change size here
      //   label: const Center(
      //     child: Text(
      //       'January',
      //       style: TextStyle(fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // ),
      GridColumn(
        columnName: 'JanWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[0],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn(
        columnName: 'JanWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[1],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn(
        columnName: 'JanWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[2],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn(
        columnName: 'JanWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[3],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
      
      GridColumn( //1
        columnName: 'FebWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[4],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'FebWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[5],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'FebWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[6],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'FebWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[7],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
      
       GridColumn( //1
        columnName: 'MarchWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[8],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'MarchWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[9],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),GridColumn( //2
        columnName: 'MarchWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[10],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'MarchWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[11],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
      
        GridColumn( //1
        columnName: 'AprilWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[12],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'AprilWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[13],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
        GridColumn( //1
        columnName: 'AprilWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[14],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
        GridColumn( //1
        columnName: 'AprilWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[15],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
       GridColumn( //1
        columnName: 'AprilWeek5',
        width: 80,
        label: Center(
      child: Text(weeks[16],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
      
         GridColumn( //1
        columnName: 'MayWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[17],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'MayWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[18],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'MayWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[19],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'MayWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[20],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
       
         GridColumn( //1
        columnName: 'JuneWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[21],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'JuneWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[22],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'JuneWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[23],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'JuneWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[24],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
       
         GridColumn( //1
        columnName: 'JulyWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[25],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'JulyWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[26],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //1
        columnName: 'JulyWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[27],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
      GridColumn( //1
        columnName: 'JulyWeek4',
        width: 80,
        label:  Center(
      child: Text(weeks[28],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //1
        columnName: 'JulyWeek5',
        width: 80,
        label: Center(
      child: Text(weeks[29],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
      
      
         GridColumn( //1
        columnName: 'AugustWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[30],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'AugustWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[31],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
       GridColumn( //1
        columnName: 'AugustWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[32],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'AugustWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[33],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
         GridColumn( //1
        columnName: 'SeptemberWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[34],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'SeptemberWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[35],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //1
        columnName: 'SeptemberWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[36],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'SeptemberWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[37],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'SeptemberWeek5',
        width: 80,
        label: Center(
      child: Text(weeks[38],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
           
         GridColumn( //1
        columnName: 'OctoberWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[39],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'OctoberWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[40],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //1
        columnName: 'OctoberWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[41],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'OctoberWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[42],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
      
        GridColumn( //1
        columnName: 'NovemberWeek1',
        width: 80,
        label:  Center(
      child: Text(weeks[43],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'NovemberWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[44],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //1
        columnName: 'NovemberWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[45],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'NovemberWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[46],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
          GridColumn( //1
        columnName: 'DecemberWeek1',
        width: 80,
        label: Center(
      child: Text(weeks[47],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'DecemberWeek2',
        width: 80,
        label: Center(
      child: Text(weeks[48],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //1
        columnName: 'DecemberWeek3',
        width: 80,
        label: Center(
      child: Text(weeks[49],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'DecemberWeek4',
        width: 80,
        label: Center(
      child: Text(weeks[50],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      GridColumn( //2
        columnName: 'DecemberWeek5',
        width: 80,
        label: Center(
      child: Text(weeks[51],
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
      
      GridColumn( //2
        columnName: 'JanuaryWeek1',
        width: 80,
        label:  Center(
      child: Text(weeks.length > 52 ? weeks[52] : '',
          style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      
      
        ],
      ),
  
     )
  
  ]
);


    
  }
}

List<String> generateWeeks(int year) {
  List<String> weeks = [];

  DateTime start = DateTime(year, 1, 1);
  DateTime end = DateTime(year, 12, 31);

  while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
    DateTime weekEnd = start.add(const Duration(days: 6));

    weeks.add(
      "${start.day}-${weekEnd.day}"
    );

    start = start.add(const Duration(days: 7));
  }

  return weeks;
}
