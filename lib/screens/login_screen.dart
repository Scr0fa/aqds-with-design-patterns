import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';
import 'dashboard.dart';
import 'register_screen.dart';

// Model
class LoginModel {
  String email = '';
  String password = '';
}

// Controller
class LoginController {
  late BuildContext context;
  late LoginModel model;

  LoginController(BuildContext context) {
    this.context = context;
    model = LoginModel();
  }

  void login() async {
    Map<dynamic, dynamic> creds = {
      'email': model.email,
      'password': model.password,
      'device_name': 'mobile',
    };
    if (Form.of(context)!.validate()) {
      try {
        await Provider.of<Auth>(context, listen: false).login(creds: creds);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Dashboard(prototype: DashboardPrototype())),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}

// View
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginController controller;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = LoginController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(30),
              children: [
                Image.asset(
                  "assets/logo1.png",
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Air Quality Detection System",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Text(
                  "Welcome!",
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Email",
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    return (value == '') ? "Input Email" : null;
                  },
                  onSaved: (value) {
                    controller.model.email = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onSaved: (value) {
                    controller.model.password = value!;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        await Provider.of<Auth>(context, listen: false).login(
                          creds: {
                            'email': controller.model.email,
                            'password': controller.model.password,
                            'device_name': 'mobile',
                          },
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Dashboard(prototype: DashboardPrototype())),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: const Text("Create Account"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
