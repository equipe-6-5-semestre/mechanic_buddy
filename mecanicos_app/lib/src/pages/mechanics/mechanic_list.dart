import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import 'mechanic.dart';
import 'mechanic_form.dart';

class MechanicList extends StatefulWidget {
  @override
  _MechanicListState createState() => _MechanicListState();
}

class _MechanicListState extends State<MechanicList> {
  late DatabaseHelper _dbHelper;
  late Future<List<Mechanic>> _mechanicList;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _mechanicList = _dbHelper.getMechanics();
  }

  void _refreshList() {
    setState(() {
      _mechanicList = _dbHelper.getMechanics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mechanics List'),
      ),
      body: FutureBuilder<List<Mechanic>>(
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MechanicForm(mechanic: mechanic),
                            ),
                          );
                          if (result == true) {
                            _refreshList();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _dbHelper.deleteMechanic(mechanic.id!);
                          _refreshList();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MechanicForm(),
            ),
          );
          if (result == true) {
            _refreshList();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
