import 'package:flutter/material.dart';
import 'package:mechanic_buddy/src/pages/mechanic_services/service.dart';
import '../../../db/database_helper.dart';
import '../mechanics/mechanic.dart';
import 'user.dart';
import '../mechanic_services/service_form.dart';
import '../mechanics/mechanic_form.dart';
import './login_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late DatabaseHelper _dbHelper;
  late Future<Mechanic?> _userMechanic;
  Future<List<Service>>? _serviceList;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadUserMechanic();
  }

  void _loadUserMechanic() {
    _userMechanic = _dbHelper.getUserMechanic(widget.user.id!);
    _userMechanic.then((mechanic) {
      if (mechanic != null) {
        setState(() {
          _serviceList = _dbHelper.getServices(mechanic.id!);
        });
      }
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Mechanic?>(
      future: _userMechanic,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Perfil'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () => _logout(context),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informações do usuário',
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
                            'Informações do mecânico',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('Nome: ${snapshot.data!.name}'),
                          Text('Telefone: ${snapshot.data!.phone}'),
                          Text('Especialização: ${snapshot.data!.specialization}'),
                          Text('Tipos de veículos: ${snapshot.data!.vehicleTypes.join(', ')}'),
                          Text('Anos de Experiência: ${snapshot.data!.experience}'),
                          Text('Cidade: ${snapshot.data!.city}'),
                          SizedBox(height: 20),
                          Row(
                            children: [
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
                                      _loadUserMechanic();
                                    });
                                  }
                                },
                                child: Text('Adicionar Serviço'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MechanicForm(
                                        userId: widget.user.id!,
                                        mechanic: snapshot.data!,
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {
                                      _loadUserMechanic();
                                    });
                                  }
                                },
                                child: Text('Atualizar Dados'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Serviços oferecidos',
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
                                      child: Text('Erro: ${serviceSnapshot.error}'));
                                } else if (!serviceSnapshot.hasData ||
                                    serviceSnapshot.data!.isEmpty) {
                                  return Center(child: Text('Não há serviços'));
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nenhum mecânico registrado'),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MechanicForm(userId: widget.user.id!),
                                ),
                              );
                              if (result == true) {
                                setState(() {
                                  _loadUserMechanic();
                                });
                              }
                            },
                            child: Text('Criar perfil de mecânico'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
