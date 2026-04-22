import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                heading,
                firstNameField,
                lastNameField,
                emailField,
                passwordField,
                submitButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get heading => const Padding(
    padding: EdgeInsets.only(bottom: 30),
    child: Text(
      "Sign Up",
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  );

  Widget get firstNameField => Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text("First Name"),
        hintText: "Enter your first name",
      ),
      onSaved: (value) => setState(() => firstName = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your first name";
        }
        return null;
      },
    ),
  );

  Widget get lastNameField => Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text("Last Name"),
        hintText: "Enter your last name",
      ),
      onSaved: (value) => setState(() => lastName = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your last name";
        }
        return null;
      },
    ),
  );

  Widget get emailField => Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text("Email"),
        hintText: "Enter a valid email",
      ),
      onSaved: (value) => setState(() => email = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a valid email format";
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return "Please enter a valid email format";
        }
        return null;
      },
    ),
  );

  Widget get passwordField => Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text("Password"),
        hintText: "At least 6 characters",
      ),
      obscureText: true,
      onSaved: (value) => setState(() => password = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a password";
        }
        if (value.length < 6) return "Password must be at least 6 characters";
        if (!RegExp(r'[a-z]').hasMatch(value))
          return "Must contain at least one lowercase letter";
        if (!RegExp(r'[A-Z]').hasMatch(value))
          return "Must contain at least one uppercase letter";
        if (!RegExp(r'\d').hasMatch(value))
          return "Must contain at least one digit";
        if (!RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]').hasMatch(value))
          return "Must contain at least one special character";
        return null;
      },
    ),
  );

  Widget get submitButton => ElevatedButton(
    onPressed: () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await context.read<UserAuthProvider>().authService.signUp(
          email!,
          password!,
          firstName!,
          lastName!,
        );

        // check if the widget hasn't been disposed of after an asynchronous action
        if (mounted) Navigator.pop(context);
      }
    },
    child: const Text("Sign Up"),
  );
}
