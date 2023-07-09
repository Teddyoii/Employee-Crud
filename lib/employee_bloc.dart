import 'dart:async';
import 'package:employee_app/employee_database.dart';
import 'package:employee_app/employee_model.dart';

class EmployeeBloc {
  final EmployeeDatabase _database = EmployeeDatabase();
  final StreamController<List<Employee>> _employeeController =
      StreamController<List<Employee>>.broadcast();

  Stream<List<Employee>> get employeeStream => _employeeController.stream;

  Future<void> initDatabase() async {
    await _database.initDatabase();
    _updateEmployeeList();
  }

  void _updateEmployeeList() async {
    final employees = await _database.getEmployees();
    _employeeController.sink.add(employees);
  }

  Future<void> addEmployee(Employee employee) async {
    await _database.addEmployee(employee);
    _updateEmployeeList();
  }

  Future<void> updateEmployee(Employee employee) async {
    await _database.updateEmployee(employee);
    _updateEmployeeList();
  }

  Future<void> deleteEmployee(Employee employee) async {
    await _database.deleteEmployee(employee);
    _updateEmployeeList();
  }

  void dispose() {
    _employeeController.close();
  }
}
