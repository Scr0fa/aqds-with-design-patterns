import 'package:flutter/material.dart';
import 'package:flutter_laravel/screens/dashboard.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'myAccount.dart';

class CustomDrawer extends StatelessWidget {
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: UniqueKey(),
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          if (auth.authenticated) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade700, Colors.blue.shade900],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: auth.user.avatar?.startsWith('http') ?? false
                                      ? NetworkImage(auth.user.avatar!)
                                      : AssetImage('user.png') as ImageProvider<Object>?,
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  auth.user.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "@${auth.user.username}",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('My Account'),
                        leading: Icon(Icons.account_circle),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyAccount()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Dashboard'),
                        leading: Icon(Icons.dashboard),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Dashboard(prototype: DashboardPrototype())),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                    );
                  },
                ),
                SizedBox(height: 30),
              ],
            );
          } else {
            return Container(); // Add this line to return a default widget
          }
        },
      ),
    );
  }
}
