import 'package:flutter/material.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:provider/provider.dart';

import 'drawer.dart';

abstract class Account extends Widget {
  // Add necessary Widget methods here
}

class MyAccount extends StatelessWidget implements Account {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('user_image.jpg'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Consumer<Auth>(
                builder: (context, auth, child) {
                  return Text('Name: ${auth.user.name}');
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Consumer<Auth>(
                builder: (context, auth, child) {
                  return Text('Email: ${auth.user.email}');
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Consumer<Auth>(
                builder: (context, auth, child) {
                  return Text('Username: ${auth.user.username}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountFactory {
  static Widget createAccount(BuildContext context) {
    return MyAccount();
  }
}
