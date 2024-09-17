import 'package:flutter/material.dart';
import 'package:leave_ez/models/leave_request.dart';
import 'package:provider/provider.dart';
import 'package:leave_ez/providers/auth_provider.dart';
import 'package:leave_ez/providers/leave_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late LeaveProvider _leaveProvider;
  late AuthProvider _authProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _fetchLeaveRequests();
  }

  Future<void> _fetchLeaveRequests() async {
    try {
      await _leaveProvider.fetchLeaveRequests(_authProvider.token!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load leave requests.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Leaves'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
            color: Colors.blue,
          )
        ],
      ),
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          await _fetchLeaveRequests();
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Consumer<LeaveProvider>(
                builder: (context, leaveProvider, child) {
                  if (leaveProvider.leaveRequests.isEmpty) {
                    return const Center(
                        child: Text('No leave requests available.'));
                  }
                  return LeaveCalendarView(
                    leaveRequests: leaveProvider.leaveRequests,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class LeaveCalendarView extends StatelessWidget {
  final List<LeaveRequest> leaveRequests;

  const LeaveCalendarView({super.key, required this.leaveRequests});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 32),
      child: SfCalendar(
        view: CalendarView.month,
        backgroundColor: Colors.white,
        headerHeight: 60,
        cellBorderColor: Colors.black38,
        headerStyle: const CalendarHeaderStyle(
            textAlign: TextAlign.center,
            backgroundColor: Colors.white,
            textStyle: TextStyle(color: Colors.blue)),
        todayHighlightColor: Colors.transparent,
        dataSource: _getCalendarDataSource(),
        showDatePickerButton: false,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          agendaItemHeight: 100,
        ),
        appointmentBuilder: (context, calendarAppointmentDetails) {
          final Appointment appointment =
              calendarAppointmentDetails.appointments.first;
          return GestureDetector(
            onTap: () {
              final Appointment appointment =
                  calendarAppointmentDetails.appointments.first;

              final leaveRequest = leaveRequests.firstWhere(
                (request) =>
                    request.id == appointment.id &&
                    request.startDate == appointment.startTime &&
                    request.endDate == appointment.endTime &&
                    "${request.employee.name} ${request.employee.surname}" ==
                        appointment.subject,
              );

              Navigator.pushNamed(context, "/employee-leave-details",
                  arguments: leaveRequest);
            },
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: appointment.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.subject,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${appointment.notes}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'From: ${appointment.startTime.day}/${appointment.startTime.month}/${appointment.startTime.year}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'To: ${appointment.endTime.day}/${appointment.endTime.month}/${appointment.endTime.year}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        monthCellBuilder: (context, details) {
          final DateTime date = details.date;
          final List<Object> appointments = details.appointments;
          bool hasAppointment = appointments.isNotEmpty;

          return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: hasAppointment ? Colors.blue : null,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: hasAppointment ? Colors.white : Colors.black,
              ),
            ),
          );
        },
        selectionDecoration: const BoxDecoration(
            color: Colors.transparent, shape: BoxShape.circle),
      ),
    );
  }

  CalendarDataSource _getCalendarDataSource() {
    final List<Appointment> appointments = [];

    for (LeaveRequest leaveRequest in leaveRequests) {
      appointments.add(
        Appointment(
          id: leaveRequest.id,
          startTime: leaveRequest.startDate,
          endTime: leaveRequest.endDate,
          subject:
              "${leaveRequest.employee.name} ${leaveRequest.employee.surname}",
          notes: leaveRequest.leaveType,
          color: leaveRequest.status == "Approved"
              ? Colors.green
              : leaveRequest.status == "Pending"
                  ? Colors.amber
                  : leaveRequest.status == "Declined"
                      ? Colors.red
                      : Colors.blue,
          isAllDay: true,
        ),
      );
    }

    return LeaveCalendarDataSource(appointments);
  }
}

class LeaveCalendarDataSource extends CalendarDataSource {
  LeaveCalendarDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
