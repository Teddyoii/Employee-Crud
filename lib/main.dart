import 'package:flutter/material.dart';
import 'package:employee_app/employee_bloc.dart';

import 'employee_list_screen.dart';

class EmployeeApp extends StatelessWidget {
  final EmployeeBloc bloc;

  const EmployeeApp({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmployeeListScreen(bloc: bloc),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final employeeBloc = EmployeeBloc();
  employeeBloc.initDatabase().then((_) {
    runApp(EmployeeApp(bloc: employeeBloc));
  });
}
