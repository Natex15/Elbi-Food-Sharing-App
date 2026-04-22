import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/user_details_page.dart';

class DrawerWidget extends StatefulWidget {
  final User? user;
  const DrawerWidget({super.key, required this.user});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white),
                  );
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!.exists) {
                  return Text(
                    widget.user!.email!,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  );
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;
                String fullName =
                    '${userData['firstName']} ${userData['lastName']}';

                return Text(
                  fullName,
                  style: GoogleFonts.pressStart2p(fontSize: 24.0, color: Colors.white)
                );
              },
            ),
            
          ),
          ListTile(
            title: Text('Add Expenses'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/addExpenses');
            }
          ),
          ListTile(
            title: Text('Expenses'),
            onTap: () => Navigator.popUntil(context, ModalRoute.withName('/')),
          ),
          ListTile(
            title: Text('User Details'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsPage(user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () => context.read<UserAuthProvider>().signOut(),
          ),
        ],
      ),
    );
  }
}
