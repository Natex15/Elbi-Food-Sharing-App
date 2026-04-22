import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exer9/common/drawer.dart';
import 'package:exer9/models/expenses_model.dart';
import 'package:exer9/providers/expenses_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ExpensesPage extends StatefulWidget {
  final User? user;
  const ExpensesPage({super.key,required this.user});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpensesProvider>().fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Object?>>? expensesStream = context
        .watch<ExpensesProvider>()
        .expenses;

    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: DrawerWidget(user: widget.user),
      body: StreamBuilder(
        stream: expensesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error encountered! ${snapshot.error}"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No Expenses Found"));
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Expenses expenses = Expenses.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              expenses.id = snapshot.data?.docs[index].id;
              return Dismissible(
                key: Key(expenses.id.toString()),
                onDismissed: (direction) {
                  context.read<ExpensesProvider>().deleteExpenses(expenses.id!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${expenses.name} dismissed')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: expenses.isPaid,
                    onChanged: (bool? val) {
                      if (val != null) {
                        context.read<ExpensesProvider>().toggleStatus(
                          expenses.id!,
                          val,
                        );
                      }
                    },
                  ),
                  title: Text(expenses.name),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/viewExpenses',
                      arguments: expenses,
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<ExpensesProvider>().deleteExpenses(
                            expenses.id!,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${expenses.name} deleted')),
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addExpenses');
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
