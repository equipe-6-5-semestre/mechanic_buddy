import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import 'mechanic.dart';

class MechanicForm extends StatefulWidget {
  final Mechanic? mechanic;
  final int userId;

  MechanicForm({this.mechanic, required this.userId});

  @override
  _MechanicFormState createState() => _MechanicFormState();
}

class _MechanicFormState extends State<MechanicForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phone;
  late String _specialization;
  List<String> _vehicleTypes = [];
  late int _experience;
  late String _city;
  late DatabaseHelper _dbHelper;

  final List<String> _allVehicleTypes = [
    'Carro',
    'Moto',
    'Caminhão',
    'Van',
    'Caminhonete'
  ];

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    if (widget.mechanic != null) {
      _name = widget.mechanic!.name;
      _phone = widget.mechanic!.phone;
      _specialization = widget.mechanic!.specialization;
      _vehicleTypes = widget.mechanic!.vehicleTypes;
      _experience = widget.mechanic!.experience;
      _city = widget.mechanic!.city;
    } else {
      _name = '';
      _phone = '';
      _specialization = '';
      _vehicleTypes = [];
      _experience = 0;
      _city = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mechanic == null ? 'Cadastrar Mecânico' : 'Atualizar Mecânico'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu telefone';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              TextFormField(
                initialValue: _specialization,
                decoration: InputDecoration(labelText: 'Especialização'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua especialização';
                  }
                  return null;
                },
                onSaved: (value) {
                  _specialization = value!;
                },
              ),
              Text(
                'Selecione os tipos de veículos:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ..._allVehicleTypes.map((type) {
                return CheckboxListTile(
                  title: Text(type),
                  value: _vehicleTypes.contains(type),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _vehicleTypes.add(type);
                      } else {
                        _vehicleTypes.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
              TextFormField(
                initialValue: _experience.toString(),
                decoration: InputDecoration(labelText: 'Anos de Experiência'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua experiencia';
                  }
                  return null;
                },
                onSaved: (value) {
                  _experience = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _city,
                decoration: InputDecoration(labelText: 'Cidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua cidade';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.mechanic == null) {
                      await _dbHelper.insertMechanic(
                        Mechanic(
                          name: _name,
                          phone: _phone,
                          specialization: _specialization,
                          vehicleTypes: _vehicleTypes,
                          experience: _experience,
                          city: _city,
                          userId: widget.userId,
                        ),
                      );
                    } else {
                      await _dbHelper.updateMechanic(
                        Mechanic(
                          id: widget.mechanic!.id,
                          name: _name,
                          phone: _phone,
                          specialization: _specialization,
                          vehicleTypes: _vehicleTypes,
                          experience: _experience,
                          city: _city,
                          userId: widget.userId,
                        ),
                      );
                    }
                    Navigator.pop(context, true);
                  }
                },
                child: Text(widget.mechanic == null ? 'Cadastrar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
