import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'drawer.dart';
import 'locations_screen.dart';

class Prototype {
  List<dynamic> locations;

  Prototype({
    required this.locations,
  });

  Prototype clone() => Prototype(locations: locations);
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final storage = FlutterSecureStorage();
  late bool isLoading = true;

  late List<dynamic> pmData = [];
  late List<String> timestamps = [];

  @override
  void initState() {
    super.initState();
    readToken();
    fetchPMData();
  }

  Future<void> readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    print(token);
  }

  Future<void> fetchPMData() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<dynamic> data = await Provider.of<Auth>(context, listen: false).fetchPM();
      List<String> extractedTimestamps = data.map((entry) => entry['timestamp'].toString()).toList();
      extractedTimestamps.sort((a, b) {
        final now = DateTime.now();
        final dateTimeA = DateTime.parse(a);
        final dateTimeB = DateTime.parse(b);
        if (dateTimeA.year == now.year && dateTimeA.month == now.month && dateTimeA.day == now.day) {
          return -1;
        } else if (dateTimeB.year == now.year && dateTimeB.month == now.month && dateTimeB.day == now.day) {
          return 1;
        } else {
          return dateTimeB.compareTo(dateTimeA);
        }
      });
      setState(() {
        pmData = data;
        timestamps = extractedTimestamps;
        isLoading = false;
      });
    } catch (error) {
      // Handle error, such as displaying an error message
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTimestamp(String timestamp) {
    final now = DateTime.now();
    final dateTime = DateTime.parse(timestamp);
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today (${dateTime.month}-${dateTime.day}-${dateTime.year})';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'Yesterday (${dateTime.month}-${dateTime.day}-${dateTime.year})';
    } else {
      return '${dateTime.month}-${dateTime.day}-${dateTime.year}';
    }
  }

  String getLocation(int index) {
    return pmData[index]['location'] ?? '';
  }

  double getPM1(int index) {
    return pmData[index]['pm1'] ?? 0.0;
  }

  double getPM25(int index) {
    return pmData[index]['pm2.5'] ?? 0.0;
  }

  double getPM10(int index) {
    return pmData[index]['pm10'] ?? 0.0;
  }

  String getRemarks(int index) {
    return pmData[index]['remarks'] ?? '';
  }

  Prototype clone() {
    List<dynamic> uLocations = [];
    for (int i = 0; i < pmData.length; i++) {
      String location = pmData[i]["location"];
      bool isLocationExists = false;
      for (int j = 0; j < uLocations.length; j++) {
        if (uLocations[j]["location"] == location) {
          isLocationExists = true;
          break;
        }
      }
      if (!isLocationExists) {
        uLocations.add({"location": location});
      }
    }
    return Prototype(locations: uLocations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: timestamps.length,
          itemBuilder: (BuildContext context, int index) {
            String timestamp = timestamps[index];
            String formattedTimestamp = formatTimestamp(timestamp);

            return Card(
              child: ListTile(
                title: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      formattedTimestamp,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location: ${getLocation(index)}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'PM1: ${getPM1(index)}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'PM2.5: ${getPM25(index)}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'PM10: ${getPM10(index)}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Remarks: ${getRemarks(index)}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      drawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Locations(prototype: clone())
            ),
          );
        },
        child: const Icon(Icons.location_pin),
      ),
    );
  }
}

