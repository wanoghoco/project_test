import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:project_test/splash.dart';

main() {
  runApp(const ProjectTestApp());
}

class ProjectTestApp extends StatefulWidget {
  const ProjectTestApp({super.key});

  @override
  State<ProjectTestApp> createState() => _ProjectTestAppState();
}

class _ProjectTestAppState extends State<ProjectTestApp> {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(home: AppSplash());
  }
}
