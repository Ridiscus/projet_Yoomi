import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // si tu utilises Riverpod
import 'pages/projects_list_page.dart'; // chemin vers ta page principale

void main() {
  runApp(
    const ProviderScope( // nécessaire pour Riverpod
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SOTRAPP', // ou le nom de ton projet
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProjectsListPage(), // ta page principale
    );
  }
}