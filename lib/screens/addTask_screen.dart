import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/models/task.dart';
import 'package:task_tracker/providers/task_provider.dart';
import 'package:task_tracker/widgets/buttons.dart';
import 'package:task_tracker/widgets/colors.dart';
import 'package:task_tracker/widgets/constants.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String? selectedPriority = 'Düşük';

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.back,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        title: const Text('Yeni Görev Ekle', style: AppTextStyles.heading),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Görev Başlığı',
                    labelStyle: TextStyle(color: AppColors.labelText),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.appBar, width: 4),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen görev başlığını girin';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Görev Açıklaması',
                    labelStyle: TextStyle(color: AppColors.labelText),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.appBar, width: 4),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen görev açıklamasını girin';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Öncelik Seçin',
                    labelStyle: TextStyle(color: AppColors.labelText),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.appBar, width: 4),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPriority = newValue;
                    });
                  },
                  items: <String>['Düşük', 'Orta', 'Yüksek']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppButtonStyles.buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: _title,
                        description: _description,
                        isCompleted: false,
                        priority: selectedPriority,
                      );
                      taskProvider.addTask(newTask);

                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
