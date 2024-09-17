import 'package:flutter/material.dart';
import 'package:leave_ez/models/leave_request.dart';
import 'package:leave_ez/providers/auth_provider.dart';
import 'package:leave_ez/providers/leave_provider.dart';
import 'package:provider/provider.dart';

class AdminLeaveDetailsScreen extends StatelessWidget {
  const AdminLeaveDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaveRequest leaveRequest =
        ModalRoute.of(context)!.settings.arguments as LeaveRequest;
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            'Name: ',
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 7,
                            child: Text(
                                '${leaveRequest.employee.name} ${leaveRequest.employee.surname}')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            'Leave Type: ',
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(flex: 7, child: Text(leaveRequest.leaveType)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            'Location: ',
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 7,
                            child: Text(leaveRequest.employee.location)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            'Department: ',
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 7,
                            child: Text(leaveRequest.employee.department)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            'Designation: ',
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 7, child: Text(leaveRequest.employee.role)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            'Reporting To: ',
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 7,
                            child: Text(leaveRequest.employee.manager)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: leaveRequest.status == 'Pending'
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        leaveProvider.approveLeaveRequest(
                          authProvider.token!,
                          leaveRequest.id,
                          'Declined',
                        );
                        Navigator.pop(context);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        'Decline',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        leaveProvider.approveLeaveRequest(
                          authProvider.token!,
                          leaveRequest.id,
                          'Approved',
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text(
                        'Approve',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Expanded(
                    child: Container(
                        height: 80,
                        color: leaveRequest.status == "Approved"
                            ? Colors.green
                            : leaveRequest.status == "Pending"
                                ? Colors.amber
                                : leaveRequest.status == "Declined"
                                    ? Colors.red
                                    : Colors.blue,
                        child: Center(
                          child: Text(
                            'Request has already been processed.',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))),
              ],
            ),
    );
  }
}
