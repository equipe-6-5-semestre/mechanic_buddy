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
    // Remover espaços e caracteres especiais do telefone
    final cleanedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri url = Uri.parse('https://wa.me/$cleanedPhone');
    
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o WhatsApp. Verifique se está instalado.')),
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
              'Informacões do Mecânico',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Nome: ${widget.mechanic.name}'),
            Text('Telefone: ${widget.mechanic.phone}'),
            Text('Especialização: ${widget.mechanic.specialization}'),
            Text('Tipos de veículos: ${widget.mechanic.vehicleTypes.join(', ')}'),
            Text('Experiência: ${widget.mechanic.experience} years'),
            Text('Cidade: ${widget.mechanic.city}'),
            SizedBox(height: 20),
            Text(
              'Serviços Oferecidos',
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
                    return Center(child: Text('Nenhum serviço encontrado'));
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
