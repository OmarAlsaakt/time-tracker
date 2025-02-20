import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../provider/project_task_provider.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onAdd;

  AddTaskDialog({required this.onAdd});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Task',
        style: TextStyle(
          color: Colors.blueAccent, // تغيير لون العنوان
        ),
      ),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Task Name',
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
            var newTask = Task(
              id: DateTime.now().toString(),
              name: _controller.text,
            );
            widget.onAdd(newTask);
            // تحديث المزود وواجهة المستخدم
            Provider.of<TimeEntryProvider>(context, listen: false)
                .addTask(newTask);
            // مسح حقل الإدخال للإدخال التالي
            _controller.clear();
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
