  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
  import 'package:gap/gap.dart';
  import 'package:syncfusion_flutter_calendar/calendar.dart';
  import 'package:intl/intl.dart';
  import 'package:firebase_core/firebase_core.dart';


  class CalendarScreen extends StatefulWidget {
    const CalendarScreen({super.key});

    @override
    State<CalendarScreen> createState() => _CalendarScreenState();
  }

  class NoteDataSource extends CalendarDataSource {
    NoteDataSource(List<Appointment> source) {
      appointments = source;
    }
  }

  class _CalendarScreenState extends State<CalendarScreen> {

  // final List<Appointment> _appointments = [];
  DateTime? selectedCalendarDate;
  late NoteDataSource _dataSource;
  final List<Appointment> _appointments = [];

Map<int, Map<DateTime, Map<Color, int>>> monthlyValues = {};
Map<int, List<Map<Color, int>>> monthlyRowTotals = {};

int getRowIndex(DateTime date) {
  final firstDay = DateTime(date.year, date.month, 1);
  final weekdayOffset = firstDay.weekday % 7;
  final dayIndex = date.day + weekdayOffset - 1;
  return dayIndex ~/ 7;
}


Future<String> saveAppointmentToFirestore({
  required String groupId,
  required DateTime date,
  required String subject,
  required Color color,
  required String patternId,
}) async {

  final now = DateTime.now();

  final DateTime dateWithTime = DateTime(
    date.year,
    date.month,
    date.day,
    now.hour,
    now.minute,
    now.second,
  );

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(groupId)
      .collection('appointments')
      .add({
    'date': dateWithTime,
    'subject': subject,
    'color': color.value,
    'patternId': patternId,   // 🔥 important
    'createdAt': FieldValue.serverTimestamp(),
  });

  return doc.id;
}

Future<void> loadAppointmentsFromFirestore(String groupId) async {
 
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(groupId)
      .collection('appointments')
      .get();

  _appointments.clear();
  monthlyValues.clear();
  monthlyRowTotals.clear();

  for (var doc in snapshot.docs) {
    final data = doc.data();
    
   


    //para mag save yung current time sa database 1
    final Timestamp? createdTs = data['createdAt'];

    String timeOnly = "";

    if (createdTs != null) {
      final DateTime createdAt = createdTs.toDate();
      timeOnly = DateFormat("MMMM dd, yyyy  •  hh:mm a").format(createdAt);
    }
    
    final now = DateTime.now();
    final DateTime date = (data['date'] as Timestamp).toDate();

    final String subject = data['subject'];
    final Color color = Color(data['color']);
    final String patternId = data['patternId'];

  final appt = Appointment(
  id: doc.id,
  startTime: date,
  endTime: date.add(const Duration(hours: 1)),
  subject: subject,
  color: color,
  // notes: timeOnly,
  notes: patternId,
  
);

    _appointments.add(appt);

    /// rebuild monthlyValues for totals
    final int? value = int.tryParse(subject);
    if (value != null) {
      final month = date.month;

      monthlyValues.putIfAbsent(month, () => {});
      monthlyValues[month]!.putIfAbsent(date, () => {});

      monthlyValues[month]![date]!.update(
        color,
        (existing) => existing + value,
        ifAbsent: () => value,
      );
    }
  }

  /// rebuild totals
  for (int m = 1; m <= 12; m++) {
    updateMonthTotals(m);
  }

  setState(() {
    _dataSource = NoteDataSource(_appointments);
  });
}

void updateMonthTotals(int month) {
  monthlyRowTotals[month] =
      List.generate(6, (_) => <Color, int>{});

  if (!monthlyValues.containsKey(month)) return;

  for (var entry in monthlyValues[month]!.entries) {
    int row = getRowIndex(entry.key);

    entry.value.forEach((color, value) {
      monthlyRowTotals[month]![row].update(
        color,
        (existing) => existing + value,
        ifAbsent: () => value,
      );
    });
  }
}




  Future<List<Appointment>> generatePatternAppointments({
  required DateTime selectedDate,
  required String text,
   required String patternId,
}) async {

  final List<Appointment> generatedAppointments = [];

  final int? value = int.tryParse(text);
  if (value == null || value <= 0) return [];

  // Example patternOffsets (adjust if yours is different)
  //not working dito
  final Map<int, Color> patternOffsets = {
    0: Colors.blue,
  8: Colors.lightBlueAccent,
  23: Colors.yellow,
  54: Colors.green,
  89: Colors.red,
  };

  for (final entry in patternOffsets.entries) {
    final date = selectedDate.add(Duration(days: entry.key));
    final color = entry.value;
    final month = date.month;

    final appt = Appointment(
      startTime: date,
      endTime: date.add(const Duration(hours: 1)),
      subject: text,
      color: color,
       notes: patternId,
    );

    generatedAppointments.add(appt);

    // 🔥 Update Firestore totals (increment)
    await updateFirestoreTotal(
      groupId: selectedGroup!,
      month: month,
      row: getRowIndex(date), // make sure this exists
      color: color,
      value: value,
    );
  }

  return generatedAppointments;
}

  @override
  void initState() {
    super.initState();
      _dataSource = NoteDataSource(_appointments);
    
  }

//andito list ng IAs
String? selectedGroup;

final List<String> groups = [
  "SANV-DUMAC",
  "NARAGSAK DMD",
  "GREAT DOMANPOT",
  "ASENSO CAR NORTE",
  "UNITED PIASURNOR",
  "PIAZ VILLASIS",
  "CARAMUTAN VILLASIS",
  "DOMANPOT SOLID",
  "ABANTE BACTAD EAST",
  "SULONG TIMACO",
];

//taga handle ng database mo to



//taga generate ng horizontal column sa tabi ng calendar
Widget buildSideCells(List<Map<Color, int>> totals) {
  return Padding(
    padding: const EdgeInsets.only(top: 60),
    child: Container(
      width: 72,
      height: 550,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Column(
        children: List.generate(6, (index) {
          return Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: index != 5
                      ? const BorderSide(color: Colors.grey)
                      : BorderSide.none,
                ),
              ),
              child: Builder(
  builder: (_) {
    final rowData = totals[index];

    if (rowData.isEmpty) return const SizedBox();

    List<InlineSpan> spans = [];

    
   

   void addValue(Color color) {
  if (rowData.containsKey(color)) {
    if (spans.isNotEmpty) {
      spans.add(const TextSpan(
        text: "/",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    spans.add(TextSpan(
      text: rowData[color].toString(),
      style: TextStyle(
        color: color, // 🔥 text becomes same as result color
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ));
  }
}

addValue(Colors.blue);
addValue(Colors.lightBlueAccent);
addValue(Colors.yellow);
addValue(Colors.green);
addValue(Colors.red);

return RichText(
  text: TextSpan(children: spans),
);
  },
),
            ),
          );
        }),
      ),
    ),
  );
}


Future<void> handleSave(DateTime selectedDate, String text) async { 
final String patternId = DateTime.now().millisecondsSinceEpoch.toString();

  if (selectedGroup == null) {
    // show error if no group selected
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select a group first")),
    );
    return;
  }

  final newAppointments =  await generatePatternAppointments(
    selectedDate: selectedDate,
    text: text,
     patternId: patternId,
  );

  final int? value = int.tryParse(text);
  if (value == null || value <= 0) return;

  final Map<int, Color> patternOffsets = {
    0: Colors.blue,
    8: Colors.lightBlueAccent,
    23: Colors.yellow,
    54: Colors.green,
    89: Colors.red,
  };

  setState(() {
    _appointments.addAll(newAppointments);
    _dataSource = NoteDataSource(_appointments);

    for (final entry in patternOffsets.entries) {
      final date = selectedDate.add(Duration(days: entry.key));
      final color = entry.value;
      final month = date.month;

      monthlyValues.putIfAbsent(month, () => {});
      monthlyValues[month]!.putIfAbsent(date, () => {});

      monthlyValues[month]![date]!.update(
        color,
        (existing) => existing + value,
        ifAbsent: () => value,
      );
    }

    for (final entry in patternOffsets.entries) {
      final date = selectedDate.add(Duration(days: entry.key));
      updateMonthTotals(date.month);
    }
  });

  // 🔵 SAVE TO FIRESTORE
for (final appt in newAppointments) {
  final docId = await saveAppointmentToFirestore(
    groupId: selectedGroup!,
    date: appt.startTime,
    subject: appt.subject,
    color: appt.color,
    patternId: patternId,
  );

  appt.id = docId; // 🔥 IMPORTANT
}




}

    @override
    Widget build(BuildContext context) {

      final DateTime now = DateTime.now();
    
      double? E600;
      return Scaffold(
          drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blueGrey ,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.analytics),
          title: const Text('Reports'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {},
        ),
      ],
    ),
  ),







        body: Column(
    children: [

      /// 🔷 TOP NAVIGATION BAR (60 height)
      Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 254, 254),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Row(
  children: [
    Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    ),
    const SizedBox(width: 10),
    const Text(
      "Calendar Dashboard",
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
            /// Left side
           
            /// Right side buttons
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Reports",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Settings",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        ),
      ),

        
Expanded(
  child: Row(
    children: [

      /// 🔹 LEFT PANEL (Mini calendar + events)
  
      Container(
        width: 240,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(

          color: Color(0xFFF5F5F5),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 0),
            )
          ],
        ),


        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Gap(30),
            /// Small Month Preview
            SizedBox(
              height: 220,
              child: SfCalendar(
                view: CalendarView.month,
                initialDisplayDate: DateTime(2026, 1, 1),
                showNavigationArrow: false,
                allowViewNavigation: false,
                viewNavigationMode: ViewNavigationMode.none,
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Today's Event",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                  )
                ],
              ),
            ),
          ],
        ),
      ),


        Container(
        width: 20,
        color: Colors.grey.shade200,

        
      ),

         Expanded(
          child: SingleChildScrollView( 

            child: Padding(
              padding: const EdgeInsets.only(
                // left: 260,
                right: 15,
                top: 25,
              ),
       
            //here
            

              child:  Row(
                
                  
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  Gap(20), 
                 Padding(
                    padding: const EdgeInsets.only(top: 60),

 
                 ),

               Gap(20),  

                             
     Expanded(
        child: SingleChildScrollView(
          child: Column(
          children: [ 

    Align(
      alignment: Alignment.centerRight,
      child: DropdownButton<String>(
        value: selectedGroup,
        hint: const Text(
      "Select Group",
      style: TextStyle(color: Colors.black),
        ),
        underline: const SizedBox(),
        items: groups.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: const TextStyle(color: Colors.black),
        ),
      );
        }).toList(),
        //pinalitan yung onChanged para ma retrive yung sa firebase
        onChanged: (String? newValue) async {
  if (newValue == null) return;

  setState(() {
    selectedGroup = newValue;
  });

  await loadAppointmentsFromFirestore(newValue);
   await loadTotalsFromFirestore(newValue);
  
},
      ),
    ),
      Gap(9),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  buildSideCells(
               monthlyRowTotals[1] ?? List.generate(6, (_) => <Color, int>{}),
),
                  Gap(8),
                  Expanded(
                  child: SizedBox(
                    height: 600,
                    child: SfCalendar(
                        view: CalendarView.month,
                        dataSource: _dataSource,
                        todayHighlightColor: Colors.blue,
                        showNavigationArrow: false,
                        allowViewNavigation: false,
                        viewNavigationMode: ViewNavigationMode.none,
                        initialDisplayDate: DateTime(2026, 1, 1),
                        monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,),
                                                  
                        appointmentBuilder: (context, details) {
                        final Appointment appt = details.appointments.first;
                        return Align(
                          child: Container(
                          
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                color: appt.color,
                                borderRadius: BorderRadius.circular(4),),
                                alignment: Alignment.centerLeft,
                                  child: Text(
                                        appt.subject,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                        );
                                        },
                                      
onTap: (CalendarTapDetails details) async {

  /// 🚫 BLOCK IF NO IA SELECTED
  if (selectedGroup == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please select an IA first"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

/// 🔵 IF CELL HAS DATA
if (details.appointments != null && details.appointments!.isNotEmpty) {

  List<Appointment> appts = details.appointments!.cast<Appointment>();

  await showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {

          return Dialog(
            child: SizedBox(
              width: 700,
              height: 500,
              child: Stack(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Hectars for IAs",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        Expanded(
                          child: Wrap(
                            spacing: 40,
                            runSpacing: 20,
                            children: appts.map((appt) {

                              final String formattedDate =
                                  DateFormat("MMMM dd, yyyy • hh:mm a")
                                      .format(appt.startTime);

return GestureDetector(
  onTap: () async {

    final TextEditingController controller =
        TextEditingController(text: appt.subject?.toString() ?? "");

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Hectar"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Value",
          ),
        ),
        actions: [
            ElevatedButton(
  onPressed: () async {

    final newValue = controller.text.trim();
    if (newValue.isEmpty) return;

    /// 🔥 UPDATE FULL PATTERN
    await updatePattern(appt, newValue);

    Navigator.pop(context);

    /// 🔄 reload database
    await loadAppointmentsFromFirestore(selectedGroup!);
    await loadTotalsFromFirestore(selectedGroup!);

    setStateDialog(() {
      appts = _appointments.where((a) =>
          a.startTime.year == details.date!.year &&
          a.startTime.month == details.date!.month &&
          a.startTime.day == details.date!.day
      ).toList();
    });

  },
  child: const Text("Update"),
),

          TextButton(
  style: TextButton.styleFrom(
    foregroundColor: Colors.red,
  ),
  onPressed: () async {

    await removedaPattern(appt);

    Navigator.pop(context);

    await loadAppointmentsFromFirestore(selectedGroup!);
    await loadTotalsFromFirestore(selectedGroup!);

    setStateDialog(() {
      appts.removeWhere((a) => a.id == appt.id);
    });

  },
  child: const Text("Delete"),
),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

        
        ],
      ),
    );
  },

  child: HectarCard(
    date: formattedDate,
    value: appt.subject?.toString() ?? "",
  ),
);

                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ➕ ADD BUTTON
                  Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () async {

                        final TextEditingController controller =
                            TextEditingController();

                        final DateTime selectedDate = details.date!;

                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Add Note"),
                            content: TextField(controller: controller),
                            actions: [

                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),

                              ElevatedButton(
                                onPressed: () async {

                                  if (controller.text.isNotEmpty) {

                                    await handleSave(
                                      selectedDate,
                                      controller.text.trim(),
                                    );

                                    /// 🔥 reload appointments
                                    await loadAppointmentsFromFirestore(selectedGroup!);

                                    /// 🔥 refresh dialog UI
                                    setStateDialog(() {
                                      appts = _appointments
                                          .where((a) =>
                                              a.startTime.year == selectedDate.year &&
                                              a.startTime.month == selectedDate.month &&
                                              a.startTime.day == selectedDate.day)
                                          .toList();
                                    });
                                  }

                                  Navigator.pop(context);
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        );
                      },

                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      );
    },
  );
}

  /// 🟢 IF CELL IS EMPTY
  else if (details.targetElement == CalendarElement.calendarCell) {

  final DateTime selectedDate = details.date ?? DateTime.now();
  final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Note"),
        content: TextField(controller: controller),
        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                handleSave(selectedDate, controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
                                        ),
                                ),
                ),
                ]
              ),
                          
                         SizedBox(height: 30),


                         Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                            buildSideCells(
                            monthlyRowTotals[2] ?? List.generate(6, (_) => <Color, int>{}),
                                  ),
                                 Gap(8),
                             Expanded(
                             child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                              dataSource: _dataSource,
                                todayHighlightColor: Colors.blue,
                                showNavigationArrow: false,
                                allowViewNavigation: false,
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 2, 1),
                                
                                monthViewSettings: const MonthViewSettings(
                                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                              
                                ),
                                appointmentBuilder: (context, details) {
                                final Appointment appt = details.appointments.first;
                                  
                                  
                                return Container(
                                  width: details.bounds.width,
                                  height: details.bounds.height,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: appt.color,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    appt.subject,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
        onTap: (CalendarTapDetails details) async {

  /// 🚫 BLOCK IF NO IA SELECTED
  if (selectedGroup == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please select an IA first"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  /// 🔵 1️⃣ IF USER TAPS EXISTING APPOINTMENT
  if (details.targetElement == CalendarElement.appointment) {

    final Appointment appt = details.appointments!.first;

    TextEditingController controller =
        TextEditingController(text: appt.subject);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Appointment"),
        content: TextField(
          controller: controller,
        ),
        actions: [

          /// ❌ DELETE
          TextButton(
            onPressed: () async {
              //parahas dapat sa buong calendar
              await removedaPattern(appt);
setState(() {});
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),

          /// 💾 SAVE EDIT
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  appt.subject = controller.text.trim();
                  _dataSource = NoteDataSource(_appointments);
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// 🟢 2️⃣ IF USER TAPS EMPTY CELL (ADD NEW)
  else if (details.targetElement == CalendarElement.calendarCell) {

  final DateTime selectedDate = details.date ?? DateTime.now();  
  final  TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Note"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                handleSave(selectedDate, controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ]
        )
                                        );
                                      }
                                    },    
                              ),
                                                  ),
                           ),
                           ]
                         ),
                              
                 const SizedBox(height: 30),
                      /// 🔹 Small March Calendar (Below February)
                      //   const Text(
                      //     "March",
                      // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10),
                              
                         Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [ 
                         buildSideCells(
                           monthlyRowTotals[3] ?? List.generate(6, (_) => <Color, int>{}),
                            ),
                                  Gap(8),
                            Expanded(
                             child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                                dataSource: _dataSource,
                                todayHighlightColor: Colors.blue,
                                  showNavigationArrow: false,
                                allowViewNavigation: false,
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 3, 1),
                                monthViewSettings: const MonthViewSettings(
                                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                                ),
                                
                              appointmentBuilder: (context, details) {
                              final Appointment appt = details.appointments.first;
                                  
                              return Container(
                                width: details.bounds.width,
                                height: details.bounds.height,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: appt.color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  appt.subject,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                                                  },
                                  
                                onTap: (CalendarTapDetails details) async {

                                    /// 🚫 BLOCK IF NO IA SELECTED
                        if (selectedGroup == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select an IA first"),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

  /// 🔵 1️⃣ IF USER TAPS EXISTING APPOINTMENT
  if (details.targetElement == CalendarElement.appointment) {

    final Appointment appt = details.appointments!.first;

    TextEditingController controller =
        TextEditingController(text: appt.subject);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Appointment"),
        content: TextField(
          controller: controller,
        ),
        actions: [

          /// ❌ DELETE
          TextButton(
            onPressed: () async{
              await removedaPattern(appt);
            setState(() {});
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),

          /// 💾 SAVE EDIT
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  appt.subject = controller.text.trim();
                  _dataSource = NoteDataSource(_appointments);
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// 🟢 2️⃣ IF USER TAPS EMPTY CELL (ADD NEW)
  else if (details.targetElement == CalendarElement.calendarCell) {

    final DateTime selectedDate = details.date!;
 final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Note"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                handleSave(selectedDate, controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ]
      )
                                );
                              }
                                              },
                                
                              ),
                                                  ),
                           ),
                           ]
                         ),
                              
                                              const SizedBox(height: 40),
                              
                        // const Text(
                        //   "April",
                        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        // const SizedBox(height: 10),
                              
                       Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                      buildSideCells(
                     monthlyRowTotals[4] ?? List.generate(6, (_) => <Color, int>{}),
                    ),
                            Gap(8),
                           Expanded(
                           child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                                // headerHeight: 40,
                                // viewHeaderHeight: 40,
                                todayHighlightColor: Colors.blue,
                                allowViewNavigation: false,
                                monthViewSettings: const MonthViewSettings(
                                  showAgenda: false,
                                ),
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 4, 1),
                                showNavigationArrow: false,
                              ),
                                                  ),
                         ),
                         ]
                       ),
                              
                            const SizedBox(height: 40),
                              
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           buildSideCells(
                           monthlyRowTotals[5] ?? List.generate(6, (_) => <Color, int>{}),
),
                                Gap(8),
                               Expanded(
                              child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                                // headerHeight: 40,
                                // viewHeaderHeight: 40,
                                todayHighlightColor: Colors.blue,
                                allowViewNavigation: false,
                                monthViewSettings: const MonthViewSettings(
                                  showAgenda: false,
                                ),
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 5, 1),
                                showNavigationArrow: false,
                              ),
                                                  ),
                            ),
                            ]
                          ),
                              
                     const SizedBox(height: 40),
                              
                  // const Text(
                  //         "June",
                  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  //         const SizedBox(height: 10),
                              
                        Row  (
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           buildSideCells(
                          monthlyRowTotals[6] ?? List.generate(6, (_) => <Color, int>{}),
),
                               Gap(8),
                               Expanded(
                              child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                                // headerHeight: 40,
                                // viewHeaderHeight: 40,
                                todayHighlightColor: Colors.blue,
                                allowViewNavigation: false,
                                monthViewSettings: const MonthViewSettings(
                                  showAgenda: false,
                                ),
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 6, 1),
                                showNavigationArrow: false,
                              ),
                                                  ),
                            ),
                            ]
                          ),
                              
                            const SizedBox(height: 40),
                              
                          //   const Text(
                          // "July",
                          // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          //    const SizedBox(height: 10),
                              
                           Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                          buildSideCells(
                           monthlyRowTotals[7] ?? List.generate(6, (_) => <Color, int>{}),
),
                              Gap(8),
                               Expanded(
                               child: SizedBox(
                                height: 600,
                                child: SfCalendar(
                                view: CalendarView.month,
                                // headerHeight: 40,
                                // viewHeaderHeight: 40,
                                todayHighlightColor: Colors.blue,
                                allowViewNavigation: false,
                                monthViewSettings: const MonthViewSettings(
                                  showAgenda: false,
                                ),
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 7, 1),
                                showNavigationArrow: false,
                                                         ),
                                                  ),
                             ),
                             ]
                           ),
                              
                             const SizedBox(height: 40),
                              
                          // const Text(
                          // "August",
                          // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          //  ),
                          //  const SizedBox(height: 10),
                              
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       buildSideCells(
                        monthlyRowTotals[8] ?? List.generate(6, (_) => <Color, int>{}),
),
                           Gap(8),
                           Expanded(
                            child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                                // headerHeight: 40,
                                // viewHeaderHeight: 40,
                                todayHighlightColor: Colors.blue,
                                allowViewNavigation: false,
                                monthViewSettings: const MonthViewSettings(
                                  showAgenda: false,
                                ),
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 8, 1),
                                showNavigationArrow: false,
                              ),
                                                  ),
                          ),
                        ]
                      ),
                        const SizedBox(height: 40),
                              
                          //  const Text(
                          // "September",
                          // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), ),
                          // const SizedBox(height: 10),
                              
                         Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                          buildSideCells(
                        monthlyRowTotals[9] ?? List.generate(6, (_) => <Color, int>{}),
),
                              Gap(8),
                             Expanded(
                             child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                                // headerHeight: 40,
                                // viewHeaderHeight: 40,
                                todayHighlightColor: Colors.blue,
                                allowViewNavigation: false,
                                monthViewSettings: const MonthViewSettings(
                                  showAgenda: false,
                                ),
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 9, 1),
                                showNavigationArrow: false,
                              ),),
                           ),
                           ]
                         ),
                              
                          const SizedBox(height: 40),
                              
                          //  const Text(
                          // "October",
                          // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          // const SizedBox(height: 10),
                              
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ 
                            buildSideCells(
                           monthlyRowTotals[10] ?? List.generate(6, (_) => <Color, int>{}),
                             ),
                                Gap(8),
                              Expanded(
                              child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                                todayHighlightColor: Colors.blue,
                                allowViewNavigation: false,
                                monthViewSettings: const MonthViewSettings(
                                  showAgenda: false,
                                ),
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 10, 1),
                                showNavigationArrow: false,
                              ),
                                                  ),
                            ),
                            ]
                          ),
                              
                          const SizedBox(height: 40),
                              
                        // const Text(
                        //   "November",
                        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        //   ),
                        // const SizedBox(height: 10),
                              
                       Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                        buildSideCells(
                        monthlyRowTotals[11] ?? List.generate(6, (_) => <Color, int>{}),
                          ),
                            Gap(8),
                           Expanded(
                           child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                                // headerHeight: 40,
                                // viewHeaderHeight: 40,
                                todayHighlightColor: Colors.blue,
                                allowViewNavigation: false,
                                monthViewSettings: const MonthViewSettings(
                                  showAgenda: false,
                                ),
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 11, 1),
                                showNavigationArrow: false,
                              ),
                                                  ),
                         ),
                         ]
                       ),
                              
                       const SizedBox(height: 40),
                              
                      // const Text(
                      //     "December",
                      //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      //                         ),
                      //                         const SizedBox(height: 10),
                              
                         Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                           buildSideCells(
                          monthlyRowTotals[12] ?? List.generate(6, (_) => <Color, int>{}),),
                              Gap(8),
                             Expanded(
                             child: SizedBox(
                              height: 600,
                              child: SfCalendar(
                                view: CalendarView.month,
                                // headerHeight: 40,
                                // viewHeaderHeight: 40,
                                todayHighlightColor: Colors.blue,
                                allowViewNavigation: false,
                                monthViewSettings: const MonthViewSettings(
                                  showAgenda: false,
                                ),
                                viewNavigationMode: ViewNavigationMode.none,
                                initialDisplayDate: DateTime(2026, 12, 1),
                                showNavigationArrow: false,
                              ),
                                                  ),
                           ),
                           ]
                         ),
                              
                          const SizedBox(height: 40), 
                            ]
                         ),
                        ),
                      ) 
                  ],
              
                ),
            )
              ),
            ),
    ]
          )
        )
    ]
        )
      );
    }



//para masave yung total sa database: 
Future<void> updateFirestoreTotal({
  required String groupId,
  required int month,
  required int row,
  required Color color,
  required int value,
}) async {

  final colorKey = getColorKey(color);

  await FirebaseFirestore.instance
      .collection('users')
      .doc(groupId)
      .collection('monthlyTotals')
      .doc(month.toString())
      .set({
    'row_${row}_$colorKey': FieldValue.increment(value),
  }, SetOptions(merge: true));
}

String getColorKey(Color color) {
  if (color == Colors.blue) return "blue";
   if (color == Colors.lightBlueAccent) return "lightblue";
  if (color == Colors.yellow) return "yellow";
  if (color == Colors.green) return "green";
  if (color == Colors.red) return "red";
  return "unknown";
}

//Loads totals from database
Future<void> loadTotalsFromFirestore(String groupId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(groupId)
      .collection('monthlyTotals')
      .get();

  monthlyRowTotals.clear();

  for (var doc in snapshot.docs) {
    final month = int.parse(doc.id);
    final data = doc.data();

    monthlyRowTotals[month] =
        List.generate(6, (_) => <Color, int>{});

    data.forEach((key, value) {
      final parts = key.split('_');
      final row = int.parse(parts[1]);
      final color = parts[2];

      monthlyRowTotals[month]![row][getColorFromKey(color)] = value;
    });
  }

  setState(() {});
}


Color getColorFromKey(String key) {
  switch (key) {
    case "blue":
      return Colors.blue;
    case "lightblue":
      return Colors.lightBlueAccent;
    case "yellow":
      return Colors.yellow;
    case "green":
      return Colors.green;
    case "red":
      return Colors.red;
    default:
      return Colors.black;
  }
}



// taga handle ng delete and edited yung dedelete niya lahat 
// icoconnect sa database pag editing di gumagana
Future<void> removedaPattern(Appointment appt) async {
  final String? patternId = appt.notes;
  final int? value = int.tryParse(appt.subject);

  if (patternId == null) return;

    final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(selectedGroup)
      .collection('appointments')
      .where('patternId', isEqualTo: patternId)
      .get();

    for (var doc in snapshot.docs) {

    final data = doc.data();

    final DateTime date = (data['date'] as Timestamp).toDate();
    final int value = int.parse(data['subject']);
    final Color color = Color(data['color']);

    /// 🔥 subtract totals
    await updateFirestoreTotal(
      groupId: selectedGroup!,
      month: date.month,
      row: getRowIndex(date),
      color: color,
      value: -value,
    );

    /// delete appointment
    await doc.reference.delete();
  }
 


  if (value == null) return;

  final Map<int, Color> patternOffsets = {
    0: Colors.blue,
    8: Colors.lightBlueAccent,
    23: Colors.yellow,
    54: Colors.green,
    89: Colors.red,
  };

  for (final entry in patternOffsets.entries) {

    // Reconstruct possible base date
    final possibleBase =
        appt.startTime.subtract(Duration(days: entry.key));

    bool patternMatch = true;

    // Check if full pattern exists
    for (final offset in patternOffsets.keys) {
      final checkDate =
          possibleBase.add(Duration(days: offset));

      final exists = _appointments.any((a) =>
          a.startTime.year == checkDate.year &&
          a.startTime.month == checkDate.month &&
          a.startTime.day == checkDate.day &&
          a.subject == appt.subject);

      if (!exists) {
        patternMatch = false;
        break;
      }
    }

    if (patternMatch) {

      // 🔥 REMOVE FULL PATTERN
      for (final offset in patternOffsets.entries) {

        final date =
            possibleBase.add(Duration(days: offset.key));

        // Remove from Firestore + local list
        _appointments.removeWhere((a) {
          bool match =
              a.startTime.year == date.year &&
              a.startTime.month == date.month &&
              a.startTime.day == date.day &&
              a.subject == appt.subject;

          if (match && a.id != null) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(selectedGroup)
                .collection('appointments')
                .doc(a.id as String)
                .delete();
          }

          return match;
        });

        // 🔥 Subtract totals from Firestore
        await updateFirestoreTotal(
          groupId: selectedGroup!,
          month: date.month,
          row: getRowIndex(date),
          color: offset.value,
          value: -value,
        );

        // 🔥 Subtract from monthlyValues
        final month = date.month;

        if (monthlyValues.containsKey(month) &&
            monthlyValues[month]!.containsKey(date)) {

          monthlyValues[month]![date]!
              .update(offset.value, (existing) => existing - value);

          if (monthlyValues[month]![date]![offset.value] == 0) {
            monthlyValues[month]!.remove(offset.value);
          }

          if (monthlyValues[month]![date]!.isEmpty) {
            monthlyValues[month]!.remove(date);
          }
        }
        await loadTotalsFromFirestore(selectedGroup!);
        updateMonthTotals(month);
      }

      break; // stop loop once matched
    }
  }
  setState(() {});
}



//heto yung bago
// Future<void> removedaPattern(Appointment appt) async {

//   final String? patternId = appt.notes;


//   if (patternId == null) return;

//   final snapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(selectedGroup)
//       .collection('appointments')
//       .where('patternId', isEqualTo: patternId)
//       .get();

//   for (var doc in snapshot.docs) {

//     final data = doc.data();

//     final DateTime date = (data['date'] as Timestamp).toDate();
//     final int value = int.parse(data['subject']);
//     final Color color = Color(data['color']);

//     /// 🔥 subtract totals
//     await updateFirestoreTotal(
//       groupId: selectedGroup!,
//       month: date.month,
//       row: getRowIndex(date),
//       color: color,
//       value: -value,
//     );

//     /// delete appointment
//     await doc.reference.delete();
//   }
//    /// 🔥 reload totals
//   await loadTotalsFromFirestore(selectedGroup!);

//   setState(() {});
// }



Future<void> updatePattern(Appointment appt, String newValue) async {
  final String? patternId = appt.notes;
  if (patternId == null) return;

  final int? oldValue = int.tryParse(appt.subject);
  final int? newVal = int.tryParse(newValue);

  if (oldValue == null || newVal == null) return;

  final int diff = newVal - oldValue;

    final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(selectedGroup)
      .collection('appointments')
      .where('patternId', isEqualTo: patternId)
      .get();

  for (var doc in snapshot.docs) {

    final data = doc.data();
    final DateTime date = (data['date'] as Timestamp).toDate();
    final Color color = Color(data['color']);

    /// 🔥 update appointment value
    await doc.reference.update({
      'subject': newValue,
    });

    /// 🔥 update totals difference
    await updateFirestoreTotal(
      groupId: selectedGroup!,
      month: date.month,
      row: getRowIndex(date),
      color: color,
      value: diff,
    );
  }

  await loadTotalsFromFirestore(selectedGroup!);

  final Map<int, Color> patternOffsets = {
    0: Colors.blue,
    8: Colors.lightBlueAccent,
    23: Colors.yellow,
    54: Colors.green,
    89: Colors.red,
  };

  for (final entry in patternOffsets.entries) {

    final possibleBase =
        appt.startTime.subtract(Duration(days: entry.key));

    bool patternMatch = true;

    for (final offset in patternOffsets.keys) {

      final checkDate =
          possibleBase.add(Duration(days: offset));

      final exists = _appointments.any((a) =>
          a.startTime.year == checkDate.year &&
          a.startTime.month == checkDate.month &&
          a.startTime.day == checkDate.day &&
          a.subject == appt.subject);

      if (!exists) {
        patternMatch = false;
        break;
      }
    }

    if (patternMatch) {

      for (final offset in patternOffsets.entries) {

        final date =
            possibleBase.add(Duration(days: offset.key));

        for (final a in _appointments) {

          if (a.startTime.year == date.year &&
              a.startTime.month == date.month &&
              a.startTime.day == date.day &&
              a.subject == appt.subject) {

            /// update firestore
            ///----- will update here -----
            await FirebaseFirestore.instance
                .collection('users')
                .doc(selectedGroup)
                .collection('appointments')
                .doc(a.id as String)
                .update({
              'subject': newValue,
            });

            /// update local
            a.subject = newValue;
          }
        }

        /// update totals difference
        await updateFirestoreTotal(
          groupId: selectedGroup!,
          month: date.month,
          row: getRowIndex(date),
          color: offset.value,
          value: diff,
        );
      }

      break;
    }
  }

  setState(() {});
}

  }





//heto yung updated te, updated code
//hindi niya ma update yung total pero old code na update niya so minerge 
// Future<void> updatePattern(Appointment appt, String newValue) async {

//   final String? patternId = appt.notes;
//   if (patternId == null) return;

//   final int? oldValue = int.tryParse(appt.subject);
//   final int? newVal = int.tryParse(newValue);

//   if (oldValue == null || newVal == null) return;

//   final int diff = newVal - oldValue;

//   final snapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(selectedGroup)
//       .collection('appointments')
//       .where('patternId', isEqualTo: patternId)
//       .get();

//   for (var doc in snapshot.docs) {

//     final data = doc.data();
//     final DateTime date = (data['date'] as Timestamp).toDate();
//     final Color color = Color(data['color']);

//     /// 🔥 update appointment value
//     await doc.reference.update({
//       'subject': newValue,
//     });

//     /// 🔥 update totals difference
//     await updateFirestoreTotal(
//       groupId: selectedGroup!,
//       month: date.month,
//       row: getRowIndex(date),
//       color: color,
//       value: diff,
//     );
//   }

//  /// 🔥 reload totals
//   await loadTotalsFromFirestore(selectedGroup!);
//   setState(() {});
// }


//   }


//Class mo for Column Hectar
class HectarCard extends StatelessWidget {
  final String date;
  final String value;

  const HectarCard({
    super.key,
    required this.date,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// DATE TEXT
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          /// VALUE BOX
          Container(
            width: 150,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF9FD3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


