import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expenses_model.dart';
import '../providers/expenses_provider.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? description;
  String? category;
  int? amount;
  bool isPaid = false;

  static final List<String> _categories = [
    "Bills",
    "Transportation",
    "Food",
    "Utilities",
    "Health",
    "Entertainment",
    "Miscellaneous",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expenses", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Name",
                    ),
                    onSaved: (String? value) {
                      name = value ?? "";
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Description",
                    ),
                    onSaved: (String? value) {
                      description = value ?? "";
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input description';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: DropdownButtonFormField<String>(
                    initialValue: null,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Category",
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    onSaved: (String? value) {
                      category = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    items: _categories.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Amount",
                    ),
                    onSaved: (String? value) {
                      amount = int.tryParse(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input amount';
                      }
                      final cost = int.tryParse(value);
                      if (cost == null || cost <= 0) {
                        return 'Please input a valid amount';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: CheckboxListTile(
                    title: Text("Is Paid?"),
                    value: isPaid,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        isPaid = value ?? false;
                      });
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                        foregroundColor: Colors.white, // Text and icon color
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Expenses newExpense = Expenses(
                            name: name ?? "",
                            description: description ?? "",
                            category: category ?? "",
                            amount: amount ?? 0,
                            isPaid: isPaid,
                          );

                          context.read<ExpensesProvider>().addExpenses(newExpense);
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Add Expenses"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
