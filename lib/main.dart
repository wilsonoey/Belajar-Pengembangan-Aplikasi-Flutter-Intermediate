// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/story_detail_page.dart';
import 'pages/tambah_cerita_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final prefs = snapshot.data as SharedPreferences;
          final token = prefs.getString('token');
          return MaterialApp.router(
            title: 'Story App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routerConfig: _router(token != null),
          );
        }
      },
    );
  }

  GoRouter _router(bool isLoggedIn) {
    return GoRouter(
      initialLocation: isLoggedIn ? '/home' : '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => RegisterPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/storyDetail/:id',
          builder: (context, state) {
            final id = state.params['id']!;
            final token = state.extra as String;
            return StoryDetailPage(storyId: id, token: token);
          },
        ),
        GoRoute(
          path: '/addStory',
          builder: (context, state) => TambahCeritaPage(),
        ),
      ],
    );
  }
}