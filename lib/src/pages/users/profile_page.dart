import 'package:flutter/material.dart';
import 'package:mechanic_buddy/src/pages/mechanic_services/service.dart';
import '../../../db/database_helper.dart';
import '../mechanics/mechanic.dart';
import 'user.dart';
import '../mechanic_services/service_form.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late DatabaseHelper _dbHelper;
  late Future<Mechanic?> _userMechanic;
  late Future<List<Service>> _serviceList;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _userMechanic = _dbHelper.getUserMechanic(widget.user.id!);
    _userMechanic.then((mechanic) {
      if (mechanic != null) {
        setState(() {
          _serviceList = _dbHelper.getServices(mechanic.id!);
        });
      }
    });
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
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Username: ${widget.user.username}'),
                  SizedBox(height: 20),
                  if (snapshot.data != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mechanic Information',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('Name: ${snapshot.data!.name}'),
                          Text('Phone: ${snapshot.data!.phone}'),
                          Text('Specialization: ${snapshot.data!.specialization}'),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ServiceForm(mechanicId: snapshot.data!.id!),
                                ),
                              );
                              if (result == true) {
                                setState(() {
                                  _userMechanic =
                                      _dbHelper.getUserMechanic(widget.user.id!);
                                  _serviceList = _dbHelper.getServices(snapshot.data!.id!);
                                });
                              }
                            },
                            child: Text('Add Service'),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Services Offered',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: FutureBuilder<List<Service>>(
                              future: _serviceList,
                              builder: (context, serviceSnapshot) {
                                if (serviceSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (serviceSnapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${serviceSnapshot.error}'));
                                } else if (!serviceSnapshot.hasData ||
                                    serviceSnapshot.data!.isEmpty) {
                                  return Center(child: Text('No services found'));
                                } else {
                                  return ListView.builder(
                                    itemCount: serviceSnapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      Service service = serviceSnapshot.data![index];
                                      return ListTile(
                                        title: Text(service.name),
                                        subtitle: Text(service.description),
                                        trailing: Text(
                                            '\$${service.price.toStringAsFixed(2)}'),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Text('No mechanic registered'),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
