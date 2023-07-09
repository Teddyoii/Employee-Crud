import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:employee_app/employee_model.dart';

class EmployeeDatabase {
  static const String _databaseName = 'employee_database.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<void> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE employees(id TEXT PRIMARY KEY, name TEXT, role TEXT, startDate INTEGER, endDate INTEGER, isPresent INTEGER DEFAULT 0)',
        );
      },
    );
  }

  Future<List<Employee>> getEmployees() async {
    final List<Map<String, dynamic>> maps = await _database!.query('employees');
    return List.generate(maps.length, (index) {
      return Employee(
        id: maps[index]['id'],
        name: maps[index]['name'],
        role: maps[index]['role'],
        startDate:
            DateTime.fromMillisecondsSinceEpoch(maps[index]['startDate']),
        endDate: DateTime.fromMillisecondsSinceEpoch(maps[index]['endDate']),
        isPresent: maps[index]['isPresent'] == 1 ? true : false,
      );
    });
  }

  Future<void> addEmployee(Employee employee) async {
    await _database!.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEmployee(Employee employee) async {
    await _database!.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<void> deleteEmployee(Employee employee) async {
    await _database!.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }
}
