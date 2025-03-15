import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFFAF3F0), // Soft background
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> todoList = [];
  TextEditingController taskController = TextEditingController();

  void addList() {
    if (taskController.text.trim().isEmpty) return;

    setState(() {
      todoList.add({
        "value": taskController.text,
        "completed": false,
      });
      taskController.clear();
      Navigator.of(context).pop(); // Close bottom sheet
    });
  }

  void deleteItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void toggleComplete(int index) {
    setState(() {
      todoList[index]["completed"] = !todoList[index]["completed"];
    });
  }

  void _showAddTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(
          top: 30, // Increased top padding for more height
          left: 20,
          right: 20,
          bottom: 40, // Added bottom padding for spacing
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Task',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20), // Increased spacing
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Enter Task...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20), // Added more space
            ElevatedButton(
              onPressed: addList,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50), // Wider button
              ),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To-Do List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        backgroundColor: Colors.teal[400],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: todoList[index]["completed"],
                        onChanged: (value) => toggleComplete(index),
                        activeColor: Colors.green,
                      ),
                      title: Text(
                        todoList[index]["value"],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          decoration: todoList[index]["completed"]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () => deleteItem(index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.teal[400],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
