import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the 'intl' package
import 'package:employee_app/employee_bloc.dart';
import 'package:employee_app/employee_model.dart';

class EditEmployeeScreen extends StatefulWidget {
  final EmployeeBloc bloc;
  final Employee employee;

  const EditEmployeeScreen({required this.bloc, required this.employee});

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = '';
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.employee.name;
    _selectedRole = widget.employee.role;
    _startDate = widget.employee.startDate;
    _endDate = widget.employee.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outlined),
            onPressed: () {
              _deleteEmployee(context, widget.employee);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
            ),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: 'Employee Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outlined, color: Colors.blue)),
            ),
          ),
          SizedBox(height: 16.0),
          _buildRolePicker(),
          SizedBox(height: 16.0),
          _buildDateRangePicker(),
          SizedBox(height: 16.0),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => _cancelEdit(context),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[50], // Background color
                      onPrimary: Colors.blue, // Text Color (Foreground color)
                    ),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () => _updateEmployee(context),
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _deleteEmployee(BuildContext context, Employee employee) {
    widget.bloc.deleteEmployee(employee);
    Navigator.pop(context);
  }

  void _cancelEdit(BuildContext context) {
    Navigator.pop(context);
  }

  Widget _buildRolePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              .map((role) => DropdownMenuItem(value: role, child: Text(role)))
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
      ],
    );
  }

  Widget _buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
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

  void _updateEmployee(BuildContext context) {
    final name = _nameController.text.trim();

    if (name.isNotEmpty && _selectedRole.isNotEmpty) {
      final updatedEmployee = Employee(
        id: widget.employee.id,
        name: name,
        role: _selectedRole,
        startDate: _startDate,
        endDate: _endDate,
        isPresent: widget.employee
            .isPresent, // Pass the isPresent value from the existing employee
      );

      widget.bloc.updateEmployee(updatedEmployee);

      Navigator.pop(context);
    }
  }
}
