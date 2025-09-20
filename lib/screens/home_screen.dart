import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../controllers/auth_controller.dart';
import 'dashboard_screen.dart';
import 'login.dart';
import 'package:get/get.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Map<String, dynamic>? userData;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await AuthService.getUser();
      setState(() {
        userData = user;
        isLoadingUser = false;
      });
    } catch (e) {
      setState(() {
        isLoadingUser = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);

    Widget buildTaskTile(Task task, TaskProvider taskProvider) {
      return Dismissible(
        key: Key(task.title),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          taskProvider.deleteTask(task);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${task.title} deleted')),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  taskProvider.toggleComplete(task);
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: task.isCompleted 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      task.description,
                      style: TextStyle(
                        color: task.isCompleted 
                            ? Colors.grey.shade500 
                            : Colors.grey,
                        decoration: task.isCompleted 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    void showAddTaskForm(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[800],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        if (_titleController.text.isNotEmpty &&
                            _descriptionController.text.isNotEmpty) {
                          final task = Task(
                            title: _titleController.text,
                            description: _descriptionController.text,
                          );
                          tasks.addTask(task);
                          Navigator.of(context).pop();
                          _titleController.clear();
                          _descriptionController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget buildTaskList() {
      final todoTasks = tasks.tasks.where((task) => !task.isCompleted).toList();
      final completedTasks = tasks.tasks.where((task) => task.isCompleted).toList();

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Avatar Section
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const DashboardScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B8AE0).withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF7B8AE0),
                      radius: 35,
                      child: isLoadingUser
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              _getUserInitials(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                if (!isLoadingUser && userData != null) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        userData!['username'] ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    await AuthService.logout();
                    Get.offAll(() => const LoginScreen());
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          
          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for your task...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[850],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          
          // Todo Tasks Section
          if (todoTasks.isNotEmpty) ...[
            const Text('Todo', style: TextStyle(color: Colors.grey, fontSize: 18)),
            const SizedBox(height: 10),
            ...todoTasks.map((task) => buildTaskTile(task, tasks)),
            const SizedBox(height: 20),
          ],
          
          // Completed Tasks Section
          if (completedTasks.isNotEmpty) ...[
            const Text('Completed', style: TextStyle(color: Colors.grey, fontSize: 18)),
            const SizedBox(height: 10),
            ...completedTasks.map((task) => buildTaskTile(task, tasks)),
          ],
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 20, 22),
      body: SafeArea(
        child: tasks.tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // User Avatar at the top even when empty
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const DashboardScreen());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7B8AE0).withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor: const Color(0xFF7B8AE0),
                                radius: 35,
                                child: isLoadingUser
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      )
                                    : Text(
                                        _getUserInitials(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          if (!isLoadingUser && userData != null) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome,',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  userData!['username'] ?? 'User',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Empty state content
                    Image.asset(
                      'assets/images/empty-list.png',
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'What do you want to do today?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tap + to add your tasks',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : buildTaskList(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: const Color(0xFF7B8AE0),
        onPressed: () => showAddTaskForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _getUserInitials() {
    if (userData == null || userData!['username'] == null) {
      return 'U';
    }
    
    String username = userData!['username'].toString();
    List<String> nameParts = username.split(' ');
    
    if (nameParts.length >= 2) {
      // First name + Last name initials
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    } else {
      // Just first letter of username
      return username[0].toUpperCase();
    }
  }
}