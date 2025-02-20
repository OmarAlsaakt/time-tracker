import 'package:flutter/foundation.dart';
import '../models/time_entry.dart';
import '../models/project.dart';
import '../models/task.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;

  // قائمة إدخالات الوقت
  List<TimeEntry> _entries = [];

  // قائمة المشاريع
  final List<Project> _projects = [
    Project(id: '1', name: 'Project Alpha', isDefault: true),
    Project(id: '2', name: 'Project Beta', isDefault: true),
    Project(id: '3', name: 'Project Gamma', isDefault: true),
  ];

  // قائمة المهام
  final List<Task> _tasks = [
    Task(id: '1', name: 'Task A'),
    Task(id: '2', name: 'Task B'),
    Task(id: '3', name: 'Task C'),
  ];

  // Getter للإرجاع قائمة الإدخالات
  List<TimeEntry> get entries => _entries;
  List<Project> get projects => _projects; // Getter للمشاريع
  List<Task> get tasks => _tasks; // Getter للمهام

  TimeEntryProvider(this.storage) {
    _loadEntriesFromStorage();
  }

  void _loadEntriesFromStorage() async {
    var storedEntries = storage.getItem('timeEntries');
    if (storedEntries != null) {
      try {
        var decodedEntries = jsonDecode(storedEntries) as List;
        _entries = List<TimeEntry>.from(
          decodedEntries.map((item) => TimeEntry.fromJson(item)),
        );
        notifyListeners();
      } catch (e) {
        print("Error decoding time entries: $e");
      }
    } else {
      print("No stored time entries found or the data is not a string.");
    }
  }

  // إضافة إدخال وقت
  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveEntriesToStorage();
    notifyListeners();
  }

  // حفظ الإدخالات إلى التخزين المحلي
  void _saveEntriesToStorage() {
    storage.setItem(
        'timeEntries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  // إضافة أو تحديث إدخال وقت
  void addOrUpdateTimeEntry(TimeEntry entry) {
    int index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry; // تحديث الإدخال الحالي
    } else {
      _entries.add(entry); // إضافة إدخال جديد
    }
    _saveEntriesToStorage();
    notifyListeners();
  }

  // حذف إدخال وقت
  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntriesToStorage();
    notifyListeners();
  }

  // إضافة مشروع
  void addProject(Project project) {
    if (!_projects.any((proj) => proj.name == project.name)) {
      _projects.add(project);
      notifyListeners();
    }
  }

  // حذف مشروع
  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  // إضافة مهمة
  void addTask(Task task) {
    if (!_tasks.any((t) => t.name == task.name)) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  // حذف مهمة
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
