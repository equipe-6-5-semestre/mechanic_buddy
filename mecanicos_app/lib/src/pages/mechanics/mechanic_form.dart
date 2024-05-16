import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import 'mechanic.dart';

class MechanicForm extends StatefulWidget {
  final Mechanic? mechanic;

  MechanicForm({this.mechanic});

  @override
  _MechanicFormState createState() => _MechanicFormState();
}

class _MechanicFormState extends State<MechanicForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phone;
  late String _specialization;
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    if (widget.mechanic != null) {
      _name = widget.mechanic!.name;
      _phone = widget.mechanic!.phone;
      _specialization = widget.mechanic!.specialization;
    } else {
      _name = '';
      _phone = '';
      _specialization = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mechanic == null ? 'Add Mechanic' : 'Edit Mechanic'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              TextFormField(
                initialValue: _specialization,
                decoration: InputDecoration(labelText: 'Specialization'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter specialization';
                  }
                  return null;
                },
                onSaved: (value) {
                  _specialization = value!;
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
                        ),
                      );
                    } else {
                      await _dbHelper.updateMechanic(
                        Mechanic(
                          id: widget.mechanic!.id,
                          name: _name,
                          phone: _phone,
                          specialization: _specialization,
                        ),
                      );
                    }
                    Navigator.pop(context, true);
                  }
                },
                child: Text(widget.mechanic == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
