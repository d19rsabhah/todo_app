import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/provider/theme_changer_provider.dart';
import 'package:todo_app/screen/myhomescreen.dart';
import 'package:todo_app/viewmodel/tasks_viewmodel.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeChanger()),
          ChangeNotifierProvider(create: (_) => TaskViewModel())
        ],
        child: Builder(builder: (BuildContext context) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: themeChanger.themeMode,
            theme: ThemeData(
                primarySwatch: Colors.blue,
                appBarTheme: const AppBarTheme(
                  backgroundColor: lighttheme,
                  titleTextStyle: TextStyle(color: lighttext),
                )),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.teal,
                appBarTheme: const AppBarTheme(
                  backgroundColor: darksecond,
                )),
            home: const MyHomeScreen(),
          );
        }));
  }
}
