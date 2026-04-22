import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expenses_model.dart';
import '../providers/expenses_provider.dart';

class EditExpenses extends StatefulWidget {
  final Expenses expense;
  const EditExpenses({super.key, required this.expense});

  @override
  State<EditExpenses> createState() => _EditExpensesState();
}

class _EditExpensesState extends State<EditExpenses> {
  final _formKey = GlobalKey<FormState>();

  late String name;
  late String description;
  late String category;
  late int amount;
  late bool isPaid;

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
  void initState() {
    super.initState();
    name = widget.expense.name;
    description = widget.expense.description;
    category = widget.expense.category;
    amount = widget.expense.amount;
    isPaid = widget.expense.isPaid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Expenses", style: TextStyle(color: Colors.white)),
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
                    initialValue: name,
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
                    initialValue: description,
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
                    value: category,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Category",
                    ),
                    onChanged: (value) {
                      setState(() {
                         category = value!;
                      });
                    },
                    onSaved: (String? value) {
                      category = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    items: _categories.map<DropdownMenuItem<String>>((String value) {
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
                    initialValue: amount.toString(),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Amount",
                    ),
                    onSaved: (String? value) {
                      amount = int.tryParse(value ?? "") ?? 0;
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
                          Expenses editedExpense = Expenses(
                            name: name,
                            description: description,
                            category: category,
                            amount: amount,
                            isPaid: isPaid,
                          );

                          context.read<ExpensesProvider>().editExpenses(widget.expense.id!, editedExpense);
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        }
                      },
                      child: Text("Save Expenses"),
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
