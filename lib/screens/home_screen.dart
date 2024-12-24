import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/models/task.dart';
import 'package:task_tracker/providers/task_provider.dart';
import 'package:task_tracker/screens/addTask_screen.dart';
import 'package:task_tracker/screens/taskDetail_screen.dart';
import 'package:task_tracker/widgets/buttons.dart';
import 'package:task_tracker/widgets/colors.dart';
import 'package:task_tracker/widgets/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Task> allTasks = [];
  List<Task> filteredTasks = [];

  void filterTasks(String query) {
    setState(() {
      filteredTasks = allTasks
          .where(
              (task) => task.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void updateTaskLists(TaskProvider taskProvider) {
    setState(() {
      allTasks = taskProvider.tasks;
      filterTasks(searchController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    taskProvider.loadTasks().then((_) {
      updateTaskLists(taskProvider);
    });
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Düşük':
        return Colors.blue;
      case 'Orta':
        return Colors.orange;
      case 'Yüksek':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.back,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        title: const Text(
          'Görev Takipçisi',
          style: AppTextStyles.heading,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              taskProvider.loadTasks().then((_) {
                updateTaskLists(taskProvider);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: filterTasks,
              decoration: InputDecoration(
                labelText: 'Görev Ara',
                hintText: 'Görev başlığı yazın',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text(
                      'Eşlenen görev bulunamadı.',
                      style: AppTextStyles.heading,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Dismissible(
                        key: Key(task.id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          taskProvider.deleteTask(task.id).then((_) {
                            updateTaskLists(taskProvider);
                          });
                        },
                        child: Card(
                          color: AppColors.appBar,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  getPriorityColor(task.priority as String),
                              child: Text(
                                task.priority!.substring(0, 1),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: task.isCompleted
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                              child: Text(task.title),
                            ),
                            subtitle: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: task.isCompleted
                                    ? Colors.grey
                                    : Colors.black54,
                              ),
                              child: Text(task.description),
                            ),
                            trailing: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                final updatedTask = Task(
                                  id: task.id,
                                  title: task.title,
                                  description: task.description,
                                  isCompleted: value!,
                                  priority: task.priority,
                                );
                                taskProvider.updateTask(updatedTask).then((_) {
                                  updateTaskLists(taskProvider);
                                });
                              },
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailScreen(task: task),
                                ),
                              );

                              if (result == true) {
                                final taskProvider = Provider.of<TaskProvider>(
                                    context,
                                    listen: false);
                                setState(() {
                                  allTasks = taskProvider.tasks;
                                  filterTasks(searchController.text);
                                });
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppButtonStyles.buttonColor,
        elevation: AppButtonStyles.elevation,
        shape: RoundedRectangleBorder(borderRadius: AppButtonStyles.shape),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          ).then((_) {
            updateTaskLists(taskProvider);
          });
        },
      ),
    );
  }
}
