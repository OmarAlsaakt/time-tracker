import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../provider/project_task_provider.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(Project) onAdd;

  AddProjectDialog({required this.onAdd});

  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Project',
        style: TextStyle(
          color: Colors.blueAccent, // تغيير لون العنوان
        ),
      ),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Project Name',
          labelStyle:
              TextStyle(color: Colors.blue), // تغيير لون النص في الـ label
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // لون الحدود
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.red), // تغيير لون نص زر الإلغاء
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(
            'Add',
            style: TextStyle(color: Colors.green), // تغيير لون نص زر الإضافة
          ),
          onPressed: () {
            var newProject = Project(
              id: DateTime.now().toString(),
              name: _controller.text,
            );
            widget.onAdd(newProject);
            Provider.of<TimeEntryProvider>(context, listen: false)
                .addProject(newProject);
            _controller.clear(); // Clear the input field
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
