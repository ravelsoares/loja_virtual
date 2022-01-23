import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();
  TextEditingController _csenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(15),
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  // ignore: missing_return
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Nome inválido';
                    }
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // ignore: missing_return
                  validator: (text) {
                    if (!RegExp(r'[a-zA-Z0-9.-_]+@[a-zA-Z0-9-_]+\..+')
                        .hasMatch(text ?? '')) {
                      return 'Email inválido';
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senha,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  // ignore: missing_return
                  validator: (text) {
                    if (_senha.text.isEmpty || _senha.text.length < 6) {
                      return 'A senha precisa ter mais de 6 digitos';
                    }
                  },
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _csenha,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    labelText: 'Confirme a Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  // ignore: missing_return
                  validator: (text) {
                    if (_csenha.text.isEmpty || _csenha.text.length < 6) {
                      return 'A senha precisa ter mais de 6 digitos';
                    } else if (_csenha.text != _senha.text) {
                      return 'As senhas estão diferentes';
                    }
                  },
                  focusNode: FocusNode(),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 44,
                  child: TextButton(
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          'name': _name.text,
                          'email': _email.text,
                        };

                        model.singUp(
                          userData: userData,
                          pass: _senha.text,
                          onSucesss: _onSucess,
                          onFail: _onFail,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSucess() {}

  void _onFail() {}
}
