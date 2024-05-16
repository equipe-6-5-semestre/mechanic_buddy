import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import 'mechanic.dart';
import 'mechanic_form.dart';
import '../users/profile_page.dart';
import '../mechanic_services/services_page.dart';
import '../users/user.dart';
import 'mechanic_details_page.dart';

class MechanicList extends StatefulWidget {
  final User user;

  MechanicList({required this.user});

  @override
  _MechanicListState createState() => _MechanicListState();
}

class _MechanicListState extends State<MechanicList> {
  late DatabaseHelper _dbHelper;
  late Future<List<Mechanic>> _mechanicList;
  late Future<Mechanic?> _userMechanic;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _mechanicList = _dbHelper.getAllMechanics();
    _userMechanic = _dbHelper.getUserMechanic(widget.user.id!);
  }

  void _refreshList() {
    setState(() {
      _mechanicList = _dbHelper.getAllMechanics();
      _userMechanic = _dbHelper.getUserMechanic(widget.user.id!);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      _buildMechanicList(),
      ProfilePage(user: widget.user),
      ServicesPage(userId: widget.user.id!),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Mechanics App'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Mechanics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FutureBuilder<Mechanic?>(
              future: _userMechanic,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                } else if (snapshot.hasData) {
                  return SizedBox.shrink(); // Hide the button if a mechanic is already registered
                } else {
                  return FloatingActionButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MechanicForm(userId: widget.user.id!),
                        ),
                      );
                      if (result == true) {
                        _refreshList();
                      }
                    },
                    child: Icon(Icons.add),
                  );
                }
              },
            )
          : null,
    );
  }

  Widget _buildMechanicList() {
    return FutureBuilder<List<Mechanic>>(
      future: _mechanicList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No mechanics found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Mechanic mechanic = snapshot.data![index];
              return ListTile(
                title: Text(mechanic.name),
                subtitle: Text(mechanic.specialization),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MechanicDetailsPage(mechanic: mechanic),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
