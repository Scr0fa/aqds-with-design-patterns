import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';

import 'login_screen.dart';

class RegisterPageFactory {
  static RegisterPage createRegisterPage() {
    return RegisterPage();
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = '';
    _passwordController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    return (value == '') ? "Please enter a username" : null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    return (value == '') ? "Please enter your full name" : null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    return (value == '') ? "Please enter a password" : null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    return (value == '') ? "Please enter an email address" : null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map creds = {
                        'username': _usernameController.text,
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'password': _passwordController.text,
                        'device_name': 'mobile',
                      };
                      bool emailValid = RegExp(
                          r"^[a-zA-Z\d.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(_emailController.text);
                      if (emailValid) {
                        try {
                          String token =
                          await Provider.of<Auth>(context, listen: false)
                              .register(creds: creds);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Email Sent'),
                                content: const Text('We sent you an email for verification.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginPage()),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "The email you entered is already in use")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid email address")),
                        );
                      }
                    }
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


