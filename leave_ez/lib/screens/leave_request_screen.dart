import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leave_ez/providers/auth_provider.dart';
import 'package:leave_ez/providers/leave_provider.dart';
import 'package:provider/provider.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  String _selectedLeaveType = 'Annual Leave';
  DateTime? _fromDate;
  DateTime? _toDate;
  String _reason = '';
  String _selectedDayType = 'Full Day';

  final List<String> leaveTypes = [
    'Annual Leave',
    'Sick Leave',
    'Family Responsibility Leave',
  ];

  int _calculateDaysDifference() {
    if (_fromDate != null && _toDate != null) {
      return _toDate!.difference(_fromDate!).inDays + 1;
    }
    return 0;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime today = DateTime.now();
    final DateTime initialDate = isStartDate
        ? (_fromDate ?? today)
        : (_fromDate ?? today).add(const Duration(days: 1));

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    int? leaveBalance = _selectedLeaveType == "Annual Leave"
        ? authProvider.user?.annualLeaveBalance
        : _selectedLeaveType == "Sick Leave"
            ? authProvider.user?.sickLeaveBalance
            : _selectedLeaveType == "Family Responsibility Leave"
                ? authProvider.user?.familyLeaveBalance
                : 0;
    final int maxDays = leaveBalance ?? 0;

    final DateTime maxEndDate = _fromDate != null
        ? _fromDate!.add(Duration(days: maxDays - 1))
        : today.add(Duration(days: maxDays - 1));

    final DateTime firstDate =
        isStartDate ? today : _fromDate!.add(const Duration(days: 1));
    final DateTime lastDate =
        isStartDate ? today.add(const Duration(days: 365)) : maxEndDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != (isStartDate ? _fromDate : _toDate)) {
      setState(() {
        if (isStartDate) {
          _fromDate = picked;
          if (_toDate != null && _toDate!.isBefore(picked)) {
            _toDate = null;
          }
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    int? leaveBalance = _selectedLeaveType == "Annual Leave"
        ? authProvider.user?.annualLeaveBalance
        : _selectedLeaveType == "Sick Leave"
            ? authProvider.user?.sickLeaveBalance
            : _selectedLeaveType == "Family Responsibility Leave"
                ? authProvider.user?.familyLeaveBalance
                : 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Leave Request")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Type"),
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Full Day'),
                        leading: Radio<String>(
                          fillColor: const WidgetStatePropertyAll(Colors.blue),
                          value: 'Full Day',
                          groupValue: _selectedDayType,
                          onChanged: (value) {
                            setState(() {
                              _selectedDayType = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Half Day'),
                        leading: Radio<String>(
                          value: 'Half Day',
                          fillColor: const WidgetStatePropertyAll(Colors.blue),
                          groupValue: _selectedDayType,
                          onChanged: (value) {
                            setState(() {
                              _selectedDayType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text("Leave Type"),
            DropdownButton<String>(
              value: _selectedLeaveType,
              items: leaveTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLeaveType = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            Text("Leave Balance: $leaveBalance days"),
            const SizedBox(height: 16),
            const Text("From"),
            GestureDetector(
              onTap: () => _selectDate(context, true),
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(
                    text: _fromDate != null
                        ? DateFormat('yyyy-MM-dd').format(_fromDate!)
                        : '',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Select start date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("To"),
            GestureDetector(
              onTap: () => _selectDate(context, false),
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(
                    text: _toDate != null
                        ? DateFormat('yyyy-MM-dd').format(_toDate!)
                        : '',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Select end date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            if (_calculateDaysDifference() > 0) ...[
              const SizedBox(height: 16),
              Text("Days: ${_calculateDaysDifference()}"),
            ],
            const SizedBox(height: 16),
            const Text("Reason"),
            TextField(
              onChanged: (value) {
                setState(() {
                  _reason = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter reason',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (authProvider.user != null) {
                        try {
                          await leaveProvider
                              .submitLeaveRequest(authProvider.token!, {
                            "employee": authProvider.user?.id,
                            "leave_type": _selectedLeaveType,
                            "reason": _reason,
                            "start_date": _fromDate.toString(),
                            "end_date": _toDate.toString(),
                            "duration": _selectedDayType,
                          });
                          if (context.mounted) Navigator.pop(context);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Something went wrong. Please try again.')),
                            );
                          }
                        }
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
