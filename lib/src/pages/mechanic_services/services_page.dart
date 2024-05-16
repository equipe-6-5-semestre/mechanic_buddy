import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import '../mechanics/mechanic.dart';

class ServicesPage extends StatefulWidget {
  final int userId;

  ServicesPage({required this.userId});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late DatabaseHelper _dbHelper;
  late Future<Mechanic?> _userMechanic;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _userMechanic = _dbHelper.getUserMechanic(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Mechanic?>(
      future: _userMechanic,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null) {
          return Center(child: Text('No mechanic registered'));
        } else {
          return Center(child: Text('Services page for mechanic ${snapshot.data!.name}'));
        }
      },
    );
  }
}
