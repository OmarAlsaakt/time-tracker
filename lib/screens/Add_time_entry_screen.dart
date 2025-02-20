import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/time_entry.dart';
import '../provider/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  late TextEditingController _timeController;
  late TextEditingController _notesController;
  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final timeEntryProvider = Provider.of<TimeEntryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
        backgroundColor: Color.fromARGB(255, 26, 133, 99),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildProjectDropdown(timeEntryProvider),
            SizedBox(
              height: 12,
            ),
            buildTaskDropdown(timeEntryProvider),
            SizedBox(
              height: 12,
            ),
            buildTextField(
                _timeController, 'Total Time (hours)', TextInputType.number),
            buildDateField(_selectedDate),
            buildTextField(_notesController, 'Notes', TextInputType.text),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 26, 133, 99),
            foregroundColor: Color.fromARGB(255, 255, 255, 255),
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: _saveTimeEntry,
          child: Text('Save Time Entry'),
        ),
      ),
    );
  }

  void _saveTimeEntry() {
    if (_timeController.text.isEmpty ||
        _selectedProjectId == null ||
        _selectedTaskId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all required fields!')));
      return;
    }

    final timeEntry = TimeEntry(
      id: DateTime.now().toString(), // Generate simple ID
      projectId: _selectedProjectId!,
      taskId: _selectedTaskId!,
      totalTime: double.parse(_timeController.text),
      date: _selectedDate,
      notes: _notesController.text,
    );

    Provider.of<TimeEntryProvider>(context, listen: false)
        .addTimeEntry(timeEntry);
    Navigator.pop(context);
  }

  Widget buildTextField(
      TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: UnderlineInputBorder(),
        ),
        keyboardType: type,
      ),
    );
  }

  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
      title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
      trailing: Icon(
        Icons.calendar_today,
        color: Color.fromARGB(255, 26, 133, 99),
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  Widget buildProjectDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedProjectId,
      onChanged: (newValue) {
        setState(() => _selectedProjectId = newValue);
      },
      items: provider.projects.map<DropdownMenuItem<String>>((project) {
        return DropdownMenuItem<String>(
          value: project.id,
          child: Text(project.name),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Project',
        border: UnderlineInputBorder(),
      ),
    );
  }

  Widget buildTaskDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTaskId,
      onChanged: (newValue) {
        setState(() => _selectedTaskId = newValue);
      },
      items: provider.tasks.map<DropdownMenuItem<String>>((task) {
        return DropdownMenuItem<String>(
          value: task.id,
          child: Text(task.name),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Task',
        border: UnderlineInputBorder(),
      ),
    );
  }
}
