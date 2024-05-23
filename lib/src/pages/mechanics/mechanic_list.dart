import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import 'mechanic.dart';
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
  late List<Mechanic> _mechanics;
  String _searchQuery = '';
  int _selectedIndex = 0;
  int _mechanicCount = 0;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _mechanicList = _dbHelper.getMechanics();
    _mechanics = [];
    _loadMechanics();
  }

  void _loadMechanics() async {
    List<Mechanic> mechanics = await _dbHelper.getMechanics();
    setState(() {
      _mechanics = mechanics;
      _mechanicCount = mechanics.length;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _loadMechanics();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      Column(
        children: [
          if (_mechanicCount > 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          Expanded(child: _buildMechanicList()),
        ],
      ),
      ProfilePage(user: widget.user),
      ServicesPage(userId: widget.user.id!),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Mechanic Buddy'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Mecânicos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
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
          return Center(child: Text('Não foram encontrados mecânicos'));
        } else {
          List<Mechanic> filteredMechanics = _mechanics.where((mechanic) {
            return mechanic.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   mechanic.phone.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   mechanic.specialization.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   mechanic.vehicleTypes.join(', ').toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   mechanic.city.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
          
          return ListView.builder(
            itemCount: filteredMechanics.length,
            itemBuilder: (context, index) {
              Mechanic mechanic = filteredMechanics[index];
              return ListTile(
                title: Text(mechanic.name),
                subtitle: Text('${mechanic.specialization}\nTipos de veículos: ${mechanic.vehicleTypes.join(', ')}'),
                isThreeLine: true,
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
