import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leave_ez/screens/admin_leave_details_screen.dart';
import 'package:leave_ez/screens/leave_details_screen.dart';
import 'package:leave_ez/screens/leave_request_screen.dart';
import 'package:leave_ez/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:leave_ez/providers/auth_provider.dart';
import 'package:leave_ez/providers/leave_provider.dart';
import 'package:leave_ez/screens/login_screen.dart';
import 'package:leave_ez/screens/leave_requests_screen.dart';
import 'package:leave_ez/screens/admin_screen.dart';

void main() {
  Get.put(ApiService());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
      ],
      child: const LeaveEZ(),
    ),
  );
}

class LeaveEZ extends StatelessWidget {
  const LeaveEZ({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          title: 'LeaveEz',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
          home: LoginScreen(),
          routes: {
            '/leave-requests': (context) => authProvider.isAuthenticated
                ? const LeaveRequestsScreen()
                : LoginScreen(),
            '/leave-request': (context) => authProvider.isAuthenticated
                ? const LeaveRequestScreen()
                : LoginScreen(),
            '/admin': (context) => authProvider.isAuthenticated
                ? const AdminScreen()
                : LoginScreen(),
            '/leave-details': (context) => authProvider.isAuthenticated
                ? const LeaveDetailsScreen()
                : LoginScreen(),
            '/employee-leave-details': (context) => authProvider.isAuthenticated
                ? const AdminLeaveDetailsScreen()
                : LoginScreen(),
            '/login': (context) => LoginScreen(),
          },
        );
      },
    );
  }
}
