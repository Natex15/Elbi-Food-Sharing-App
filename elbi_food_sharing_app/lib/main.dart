import 'package:exer9/models/expenses_model.dart';
import 'package:exer9/providers/auth_provider.dart';
import 'package:exer9/providers/expenses_provider.dart';
import 'package:exer9/screens/add_expenses_page.dart';
import 'package:exer9/screens/edit_expenses_page.dart';
import 'package:exer9/screens/home_page.dart';
import 'package:exer9/screens/view_expenses_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => ExpensesProvider())),
        ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Tracker',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/addExpenses': (context) => const AddExpenses(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/viewExpenses') {
          final expenses = settings.arguments as Expenses;
          return MaterialPageRoute(
            builder: (context) => ViewExpenses(expenses),
          );
        } else if (settings.name == '/editExpenses') {
          final expenses = settings.arguments as Expenses;
          return MaterialPageRoute(
            builder: (context) => EditExpenses(expense: expenses),
          );
        }
        return null;
      },
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
