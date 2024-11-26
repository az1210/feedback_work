import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './utility/theme.dart';
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //   apiKey: "AIzaSyDTX8feb7JciLRcMpzISJDUjRWRo57XxkY",
      //   authDomain: "feedback-work-61234.firebaseapp.com",
      //   databaseURL: "https://feedback-work-61234-default-rtdb.firebaseio.com",
      //   projectId: "feedback-work-61234",
      //   storageBucket: "feedback-work-61234.appspot.com",
      //   messagingSenderId: "583751085628",
      //   appId: "1:583751085628:web:363db814f62e525f50dd39",
      //   measurementId: "G-18GL8LD6DE",
      // ),
      );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Feedback Work',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
