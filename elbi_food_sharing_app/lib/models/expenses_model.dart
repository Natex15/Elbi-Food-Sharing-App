import 'dart:convert';

class Expenses {
  String? id;
  String name;
  String description;
  String category;
  int amount;
  bool isPaid;

  Expenses({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.amount,
    this.isPaid = false,
  });

  factory Expenses.fromJson(Map<String, dynamic> json) {
    return Expenses(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      amount: json['amount'],
      isPaid: json['isPaid'] ?? false,
    );
  }

  static List<Expenses> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Expenses>((dynamic d) => Expenses.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'amount': amount,
      'isPaid': isPaid,
    };
  }
}
