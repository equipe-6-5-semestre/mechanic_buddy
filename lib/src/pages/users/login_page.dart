import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import '../mechanics/mechanic_list.dart';
import 'user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Usuário'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome de usuário';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    User? user = await _dbHelper.getUser(username, password);
                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MechanicList(user: user)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Usuário ou senha inválidos.')),
                      );
                    }
                  }
                },
                child: Text('Entrar'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _showRegisterDialog(context);
                },
                child: Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final _registerFormKey = GlobalKey<FormState>();
        final _registerUsernameController = TextEditingController();
        final _registerPasswordController = TextEditingController();

        return AlertDialog(
          title: Text('Cadastro'),
          content: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _registerUsernameController,
                  decoration: InputDecoration(labelText: 'Nome de Usuário'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome de usuário';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _registerPasswordController,
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_registerFormKey.currentState!.validate()) {
                  String username = _registerUsernameController.text;
                  String password = _registerPasswordController.text;
                  await _dbHelper.insertUser(User(username: username, password: password));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Conta criada com sucesso.')),
                  );
                }
              },
              child: Text('Cadastrar'),
            ),
          ],
        );
      },
    );
  }
}
