import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../provider/project_task_provider.dart';
import 'add_time_entry_screen.dart';
import 'package:intl/intl.dart';
import '../models/time_entry.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracking"),
        backgroundColor: Color.fromARGB(255, 26, 133, 99),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color.fromARGB(255, 255, 234, 1),
          labelColor: Colors.white,
          unselectedLabelColor: const Color.fromARGB(179, 15, 8, 8),
          tabs: [
            Tab(text: "All Entries"),
            Tab(text: "Grouped By Project"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 26, 133, 99)),
              child: Center(
                // استخدم Center لجعل النص في المنتصف
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.business_center,
                  color:
                      Color.fromARGB(255, 0, 0, 0)), //color: Colors.deepPurple
              title: Text('Projects',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                  )),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.task, color: Color.fromARGB(255, 0, 0, 0)),
              title: Text('Tasks',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                  )),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tasks');
                // Navigate to settings screen
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildEntriesByDate(context),
          buildEntriesByProject(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 234, 1),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
        ),
        tooltip: 'Add Time Entry',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildEntriesByDate(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: const Color.fromARGB(255, 177, 175, 175),
                  size: 60.0,
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text("No time entries yet!",
                    style: TextStyle(
                        color: Color.fromARGB(150, 0, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 12.0,
                ),
                Text("Tap the + button to add your first entry.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
            final entry = provider.entries[index];
            String formattedDate =
                DateFormat('MMM dd, yyyy').format(entry.date);
            String projectName = getProjectNameById(context, entry.projectId);
            String taskName = getTaskNameById(context, entry.taskId);
            return Dismissible(
              key: Key(entry.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.deleteTimeEntry(entry.id);
              },
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                color: const Color.fromARGB(255, 252, 252, 252),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    '$projectName - $taskName',
                    style: TextStyle(
                      // fontSize: 20, // حجم الخط أكبر
                      color: Color.fromARGB(255, 33, 146, 142), // لون مختلف
                      fontWeight: FontWeight.bold, // جعل النص عريضًا
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Time: ${entry.totalTime} hours',
                      ),
                      Text(
                        'Date: $formattedDate',
                      ),
                      Text(
                        'Notes: ${entry.notes}',
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildEntriesByProject(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: const Color.fromARGB(255, 177, 175, 175),
                  size: 60.0,
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text("No time entries yet!",
                    style: TextStyle(
                        color: Color.fromARGB(150, 0, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 12.0,
                ),
                Text("Tap the + button to add your first entry.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          );
        }

        // Group entries by project
        var grouped = {};
        for (var entry in provider.entries) {
          grouped.putIfAbsent(entry.projectId, () => []).add(entry);
        }

        return ListView(
          children: grouped.entries.map((entry) {
            String projectName = getProjectNameById(context, entry.key);
            return Card(
              color: const Color.fromARGB(255, 252, 252, 252),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      ' $projectName',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 33, 146, 142),
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      TimeEntry timeEntry = entry.value[index];
                      String formattedDate =
                          DateFormat('MMM dd, yyyy').format(timeEntry.date);
                      String taskName =
                          getTaskNameById(context, timeEntry.taskId);

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '- ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '$taskName: ${timeEntry.totalTime} hours ($formattedDate)',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

String getProjectNameById(BuildContext context, String projectId) {
  var provider = Provider.of<TimeEntryProvider>(context, listen: false);
  var project = provider.projects.firstWhere(
    (proj) => proj.id == projectId,
    orElse: () =>
        Project(id: projectId, name: 'Unknown Project'), // كائن افتراضي
  );
  return project.name; // ستظل هذه القيمة صحيحة
}

String getTaskNameById(BuildContext context, String taskId) {
  var provider = Provider.of<TimeEntryProvider>(context, listen: false);
  var task = provider.tasks.firstWhere(
    (tsk) => tsk.id == taskId,
    orElse: () => Task(id: taskId, name: 'Unknown Task'), // كائن افتراضي
  );
  return task.name; // ستظل هذه القيمة صحيحة
}
