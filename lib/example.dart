import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreenHE extends StatefulWidget {
  const CalendarScreenHE ({super.key});

  @override
  State<CalendarScreenHE> createState() => _CalendarScreenHEState();
}

class _CalendarScreenHEState extends State<CalendarScreenHE> {

  late List<Appointment> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SfCalendar(

  view: CalendarView.month,
  initialDisplayDate: DateTime(2019, 12, 1),
  dataSource: MeetingDataSource(_appointments),
  monthViewSettings: const MonthViewSettings(
    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
  ),

  appointmentBuilder: (context, details) {
    final Appointment appointment = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        appointment.subject,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  },
)
    );
  }

  List<Appointment> _getAppointments() {
    final DateTime now = DateTime(2019, 12, 1);

    return <Appointment>[
      Appointment(
        startTime: DateTime(2019, 12, 3, 9),
        endTime: DateTime(2019, 12, 3, 10),
        subject: 'Support',
        color: Colors.red,
      ),
      Appointment(
        startTime: DateTime(2019, 12, 3, 11),
        endTime: DateTime(2019, 12, 3, 12),
        subject: 'Scrum',
        color: Colors.grey,
      ),
      Appointment(
        startTime: DateTime(2019, 12, 4, 9),
        endTime: DateTime(2019, 12, 4, 10),
        subject: 'Consulting',
        color: Colors.blue,
      ),
      Appointment(
        startTime: DateTime(2019, 12, 5, 9),
        endTime: DateTime(2019, 12, 5, 10),
        subject: 'General',
        color: Colors.green,
      ),
      Appointment(
        startTime: DateTime(2019, 12, 12, 9),
        endTime: DateTime(2019, 12, 12, 10),
        subject: 'Project',
        color: Colors.indigo,
      ),
      Appointment(
        startTime: DateTime(2019, 12, 14, 9),
        endTime: DateTime(2019, 12, 14, 10),
        subject: 'Development',
        color: Colors.purple,
      ),
    ];
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
