import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExpensesApi {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> addExpenses(Map<String, dynamic> expenses) async {
    try {
      final String? uid = auth.currentUser?.uid;
      expenses['userId'] = uid;
      await db.collection("expenses").add(expenses);

      return "Successfully added expenses";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllExpenses() {
    final String? uid = auth.currentUser?.uid;
    return db.collection("expenses").where('userId', isEqualTo: uid).snapshots();
  }

  Future<String> editExpenses(String id, Map<String, dynamic> expenses) async {
    try {
      await db.collection("expenses").doc(id).update(expenses);
      return "Successfully edited expenses";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteExpenses(String id) async {
    try {
      await db.collection("expenses").doc(id).delete();
      return "Successfully deleted expenses";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
