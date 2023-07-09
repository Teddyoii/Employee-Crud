import 'package:flutter/material.dart';
import 'package:employee_app/employee_bloc.dart';
import 'package:employee_app/employee_model.dart';
import 'package:intl/intl.dart';

import 'add_employee_screen.dart';
import 'edit_employee_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  final EmployeeBloc bloc;

  const EmployeeListScreen({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: StreamBuilder<List<Employee>>(
        stream: bloc.employeeStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final employees = snapshot.data!;
            final currentEmployees =
                employees.where((employee) => employee.isPresent).toList();
            final pastEmployees =
                employees.where((employee) => !employee.isPresent).toList();
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildEmployeeList(
                      context, 'Current Employees', currentEmployees),
                  _buildEmployeeList(
                      context, 'Previous Employees', pastEmployees),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: Image.asset(
                'assets/loading.png',
                width: 250,
                height: 250,
              ),
            );
          }
        },
      ),
      floatingActionButton: RawMaterialButton(
        onPressed: () => _addEmployee(context),
        elevation: 2.0,
        fillColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        constraints: BoxConstraints.tightFor(
          width: 48.0,
          height: 48.0,
        ),
      ),
    );
  }

  Widget _buildEmployeeList(
      BuildContext context, String title, List<Employee> employees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return Dismissible(
              key: Key(employee.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => bloc.deleteEmployee(employee),
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(employee.name),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      employee.role,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'From ${DateFormat('dd MMM, yyyy').format(employee.startDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Divider()
                  ],
                ),
                onTap: () => _editEmployee(context, employee),
              ),
            );
          },
        ),
      ],
    );
  }

  void _addEmployee(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEmployeeScreen(bloc: bloc),
      ),
    );
  }

  void _editEmployee(BuildContext context, Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditEmployeeScreen(bloc: bloc, employee: employee),
      ),
    );
  }
}
