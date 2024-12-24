import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/widgets/buttons.dart';
import 'package:task_tracker/widgets/colors.dart';
import 'package:task_tracker/widgets/constants.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  String? selectedPriority;

  @override
  void initState() {
    super.initState();
    _title = widget.task.title;
    _description = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.back,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        title: const Text(
          'Görev Detayları',
          style: AppTextStyles.heading,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, taskProvider);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                  labelStyle: TextStyle(color: AppColors.labelText),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appBar, width: 2),
                  ),
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Başlık boş bırakılamaz.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                  labelStyle: TextStyle(color: AppColors.labelText),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appBar, width: 2),
                  ),
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Açıklama boş bırakılamaz.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: InputDecoration(
                  labelText: 'Öncelik',
                  labelStyle: TextStyle(color: AppColors.labelText),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appBar, width: 2),
                  ),
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                items: const [
                  DropdownMenuItem<String>(
                    child: Text("Düşük"),
                    value: "Düşük",
                  ),
                  DropdownMenuItem<String>(
                    child: Text("Orta"),
                    value: "Orta",
                  ),
                  DropdownMenuItem<String>(
                    child: Text("Yüksek"),
                    value: "Yüksek",
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    selectedPriority = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final updatedTask = Task(
                      id: widget.task.id,
                      title: _title,
                      description: _description,
                      isCompleted: widget.task.isCompleted,
                      priority: selectedPriority,
                    );
                    taskProvider.updateTask(updatedTask);

                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Güncelle'),
                style: AppButtonStyles.elevatedButtonStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Görevi Sil'),
        content: const Text('Bu görevi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              taskProvider.deleteTask((widget.task.id));
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
