import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/provider/theme_changer_provider.dart';
import 'package:todo_app/viewmodel/tasks_viewmodel.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
          title: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.check,
              size: 20,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            'ToDo Lists',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(width: 150),
        ],
      )),
      body: Consumer<TaskViewModel>(builder: (context, taskProvider, _) {
        return ListView.separated(
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return TaskWidget(
                task: task,
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: primary,
                height: 1,
                thickness: 1,
              );
            },
            itemCount: taskProvider.tasks.length);
      }),
      floatingActionButton: const CustomFAB(),
    );
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      title: Text(
        task.taskName,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "${task.date}, ${task.time}",
        style: TextStyle(color: textBlue),
      ),
    );
  }
}

class CustomFAB extends StatelessWidget {
  const CustomFAB({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 119, 168, 209),
        onPressed: () {
          // TODO: Add Tasks
          showDialog(
              context: context,
              builder: (builder) {
                return CustomDialog();
              });
        },
        child: Icon(
          Icons.add,
          size: 45,
        ));
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double sh = MediaQuery.sizeOf(context).height;
    double sw = MediaQuery.sizeOf(context).width;
    final taskProvider = Provider.of<TaskViewModel>(context, listen: false);
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Dialog(
      backgroundColor: secondary,
      child: SizedBox(
        height: sh * 0.6,
        width: sw * 0.8,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Create New Task",
                  style: TextStyle(color: text, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "What has to be done ?",
                style: TextStyle(color: textBlue, fontSize: 16),
              ),
              CustomTextField(
                hint: "Enter a task",
                onChanged: (value) {
                  taskProvider.setTaskName(value);
                },
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Due Date",
                style: TextStyle(color: textBlue, fontSize: 16),
              ),
              CustomTextField(
                readOnly: true,
                hint: "Enter a date",
                icon: Icons.calendar_today,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2050));
                  taskProvider.setDate(date);
                },
                controller: taskProvider.dateController,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                readOnly: true,
                hint: "Enter a time",
                icon: Icons.timer,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  taskProvider.setTime(time);
                },
                controller: taskProvider.timeController,
              ),
              const SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      await taskProvider.addTask();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Create',
                      style: TextStyle(color: primary),
                    )),
              ),
              RadioListTile<ThemeMode>(
                title: Icon(Icons.light_mode),
                value: ThemeMode.light,
                groupValue: themeChanger.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeChanger.setTheme(value);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Icon(Icons.dark_mode),
                value: ThemeMode.dark,
                groupValue: themeChanger.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeChanger.setTheme(value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      this.icon,
      this.onTap,
      this.readOnly = false,
      this.onChanged,
      this.controller});
  final String hint;
  final IconData? icon;
  final void Function()? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      style: TextStyle(color: text),
      decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: onTap,
              child: Icon(
                icon,
                color: Colors.white,
              )),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16)),
    );
  }
}

// AppBar _buildAppBar() {
//   return AppBar(
//     backgroundColor: primary,
//     title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: []),
//   );
// }

// Container(
//         height: 120,
//         width: 100,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             RadioListTile<ThemeMode>(
//               value: ThemeMode.light,
//               groupValue: themeChanger.themeMode,
//               onChanged: (ThemeMode? value) {
//                 if (value != null) {
//                   themeChanger.setTheme(value);
//                 }
//               },
//             ),
//             RadioListTile<ThemeMode>(
//               //   title: Icon(Icons.dark_mode),
//               value: ThemeMode.dark,
//               groupValue: themeChanger.themeMode,
//               onChanged: (ThemeMode? value) {
//                 if (value != null) {
//                   themeChanger.setTheme(value);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
