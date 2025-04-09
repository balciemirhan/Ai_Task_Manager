
import 'package:flutter/material.dart';
import 'package:myapp/features/tasks/data/models/task_collection.dart';
import 'package:myapp/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:myapp/features/tasks/presentation/bloc/task_event.dart';

class AddTaskDialog extends StatefulWidget {
  final TaskBloc taskBloc;

  const AddTaskDialog({super.key, required this.taskBloc});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? now,
      firstDate: now,
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDueDate ?? now),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = TaskCollection(
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        dueDate: _selectedDueDate,
        createdAt: DateTime.now(),
        isCompleted: false,
      );
      widget.taskBloc.add(AddTask(newTask));
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView( // Allows scrolling if content overflows
          child: Column(
            mainAxisSize: MainAxisSize.min, // Take minimum space
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 3, // Allow multiple lines for description
              ),
              const SizedBox(height: 16),
              // Due Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDueDate == null
                          ? 'No due date'
                          : 'Due: ${MaterialLocalizations.of(context).formatMediumDate(_selectedDueDate!)} ${TimeOfDay.fromDateTime(_selectedDueDate!).format(context)}',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    tooltip: 'Select Due Date',
                    onPressed: _pickDueDate,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Add Task'),
          onPressed: _addTask,
        ),
      ],
    );
  }
}
