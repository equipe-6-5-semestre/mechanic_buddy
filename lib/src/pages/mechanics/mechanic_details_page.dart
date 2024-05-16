import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../db/database_helper.dart';
import 'mechanic.dart';
import '../mechanic_services/service.dart';

class MechanicDetailsPage extends StatefulWidget {
  final Mechanic mechanic;

  MechanicDetailsPage({required this.mechanic});

  @override
  _MechanicDetailsPageState createState() => _MechanicDetailsPageState();
}

class _MechanicDetailsPageState extends State<MechanicDetailsPage> {
  late DatabaseHelper _dbHelper;
  late Future<List<Service>> _serviceList;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _serviceList = _dbHelper.getServices(widget.mechanic.id!);
  }

  void _launchWhatsApp(String phone) async {
    final phoneParsed = phone.replaceAll(RegExp(r'[ \-\(\)]'), '');
    print('SAD' + phoneParsed);
    final url = 'https://wa.me/$phoneParsed';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mechanic.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mechanic Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Name: ${widget.mechanic.name}'),
            Text('Phone: ${widget.mechanic.phone}'),
            Text('Specialization: ${widget.mechanic.specialization}'),
            SizedBox(height: 20),
            Text(
              'Services Offered',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Service>>(
                future: _serviceList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No services found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Service service = snapshot.data![index];
                        return ListTile(
                          title: Text(service.name),
                          subtitle: Text(service.description),
                          trailing: Text('\$${service.price.toStringAsFixed(2)}'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _launchWhatsApp(widget.mechanic.phone),
        child: Icon(Icons.message),
      ),
    );
  }
}
