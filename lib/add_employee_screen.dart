import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'employee_bloc.dart';
import 'employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  final EmployeeBloc bloc;

  const AddEmployeeScreen({required this.bloc});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _isPresent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
              ),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: 'Employee Name',
                    border: OutlineInputBorder(),
                    prefixIcon:
                        Icon(Icons.person_outlined, color: Colors.blue)),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.blue, // <-- SEE HERE
              ),
              value: _selectedRole.isNotEmpty ? _selectedRole : null,
              items: [
                'Product Designer',
                'Flutter Developer',
                'QA Tester',
                'Product Owner',
              ]
                  .map((role) =>
                      DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedRole = value!),
              decoration: InputDecoration(
                hintText: 'Select role',
                prefixIcon: Icon(
                  Icons.work_outline,
                  color: Colors.blue,
                ),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            SizedBox(height: 18.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat('MM/dd/yyyy').format(_startDate),
                    ),
                    onTap: () => _showDatePicker(context, true),
                    decoration: InputDecoration(
                      hintText: 'Start Date',
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.arrow_right_alt_outlined,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat('MM/dd/yyyy').format(_endDate),
                    ),
                    onTap: () => _showDatePicker(context, false),
                    decoration: InputDecoration(
                      hintText: 'End Date',
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            CheckboxListTile(
              title: Text('Is Present'),
              value: _isPresent,
              onChanged: (value) {
                setState(() {
                  _isPresent = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: () => _addEmployee(context),
                child: Text('Add Employee'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context, bool isStartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  void _addEmployee(BuildContext context) {
    final name = _nameController.text.trim();

    if (name.isNotEmpty && _selectedRole.isNotEmpty) {
      final newEmployee = Employee(
        id: Uuid().v4(),
        name: name,
        role: _selectedRole,
        startDate: _startDate,
        endDate: _endDate,
        isPresent: _isPresent,
      );

      widget.bloc.addEmployee(newEmployee);

      Navigator.pop(context);
    }
  }
}
