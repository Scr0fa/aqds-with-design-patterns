import 'package:flutter/material.dart';
import 'dashboard.dart';
class Locations extends StatefulWidget {
  final Prototype prototype;

  const Locations({required this.prototype, Key? key}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  late Prototype loc;

  @override
  void initState() {
    loc = widget.prototype.clone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locations"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: loc.locations.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text("${loc.locations[index]["location"]}"),
              ),
            );
          },
        ),
      ),
    );
  }
}