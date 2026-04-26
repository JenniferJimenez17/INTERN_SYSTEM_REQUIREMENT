import 'package:agno_project/home.dart';
import 'package:agno_project/reports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IrrigationAssociationsPage extends StatefulWidget {
  const IrrigationAssociationsPage({super.key});

  @override
  State<IrrigationAssociationsPage> createState() =>
      _IrrigationAssociationsPageState();
}

class _IrrigationAssociationsPageState extends State<IrrigationAssociationsPage> {
  
  int assignedStaff = 2;

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
      "Irrigation Associations",
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
          onTap: () {
             Navigator.push(
             context,
            MaterialPageRoute(
              builder: (context) => Reports(),
            ),
          );
          },
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
                        Text("Irrigation Associations",
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
                ),
  onPressed: () async {
      final TextEditingController nameCntrl = TextEditingController();
      final TextEditingController locationCntrl = TextEditingController();
  await showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          final String createdDate =
               DateTime.now().toString().split(' ')[0];

          return Dialog(
  backgroundColor: Colors.green.shade900, // ✅ main background
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  child: SizedBox(
    width: 700,
    height: 500,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          const Text(
            'Add Association',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // ✅ white text
            ),
          ),

          const SizedBox(height: 20),

          /// NAME FIELD
          TextField(
            controller: nameCntrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Name of Association',
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.green.shade800,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 15),

          /// LOCATION FIELD
          TextField(
            controller: locationCntrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Location',
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.green.shade800,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 15),

          /// DATE
          Text(
            'Date Created: $createdDate',
            style: const TextStyle(color: Colors.white70),
          ),

          const Spacer(),

          /// BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade400,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  final iaName = nameCntrl.text.trim().toUpperCase();
                  final location = locationCntrl.text.trim();

                  if (iaName.isEmpty) return;

                  try {
                    final query = await FirebaseFirestore.instance
                        .collection('users')
                        .where('name', isEqualTo: iaName)
                        .get();

                    if (query.docs.isNotEmpty) {
                      print('IA "$iaName" already exist');
                      return;
                    }

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(iaName)
                        .set({
                      'name': iaName,
                      'location': location,
                      'createdDate': createdDate,
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    print("Error adding IA: $e");
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
        },
      );
    },
  );
},
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add Association",
                  style: TextStyle(color: Colors.white),
                ),
              ),
                  ],
                ),

                const SizedBox(height: 20),

                /// STATS
                StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('users').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return const Text("No data");
    }

    final docs = snapshot.data!.docs;

    final totalAssociations = docs.length;

    final withLocations = docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final location = data['location'];
      return location != null && location.toString().trim().isNotEmpty;
    }).length;

    return Row(
      children: [
        _buildStatCard("TOTAL ASSOCIATIONS", totalAssociations),
        const SizedBox(width: 10),
        _buildStatCard("WITH LOCATIONS", withLocations),
        const SizedBox(width: 10),
        _buildStatCard("ASSIGNED STAFF", assignedStaff), // still static
      ],
    );
  },
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
                      Expanded(child: Text("ASSOCIATION", style: TextStyle(color: Colors.white70))),
                      Expanded(child: Text("LOCATION", style: TextStyle(color: Colors.white70))),
                      Expanded(child: Text("STAFF", style: TextStyle(color: Colors.white70))),
                      Expanded(child: Text("CREATED", style: TextStyle(color: Colors.white70))),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// LIST
               Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data == null) {
        return const Center(child: Text("No data"));
      }

      final docs = snapshot.data!.docs;

      return ListView.builder(
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final data = docs[index].data() as Map<String, dynamic>;

          final name = data['name'] ?? '';
          final location = data['location'] ?? '';
          String createdFormatted = '';

if (data['createdDate'] != null && data['createdDate'].toString().isNotEmpty) {
  try {
    final parsedDate = DateTime.parse(data['createdDate']);
    createdFormatted = DateFormat('MMMM dd, yyyy').format(parsedDate);
  } catch (e) {
    createdFormatted = data['createdDate']; // fallback if parsing fails
  }
}

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                
                /// NAME ONLY (no description anymore)
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                /// LOCATION
                Expanded(
                  child: Text(
                    location.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                /// STAFF (BLANK as requested)
                const Expanded(
                  child: Text(
                    "",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                /// CREATED DATE
                Expanded(
                  child: Text(
                    createdFormatted,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
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