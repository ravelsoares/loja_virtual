import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool ocultarSenha = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: const Text(
              'Criar conta',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(15),
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // ignore: missing_return
                  validator: (text) {
                    if (text.isEmpty || !text.contains('@')) {
                      return 'Email inválido';
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.email),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ocultarSenha = !ocultarSenha;
                        });
                      },
                      icon: Icon(Icons.remove_red_eye),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: ocultarSenha,
                  // ignore: missing_return
                  validator: (text) {
                    if (text.isEmpty || text.length < 6) {
                      return 'Senha inválida';
                    }
                  },
                  focusNode: FocusNode(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueci minha senha',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: TextButton(
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor)),
                    onPressed: () {
                      print('oi');
                      print(_emailController.text);
                      print(_passController.text);
                      if (_formKey.currentState.validate()) {}

                      model.signIn(
                        email: _emailController.text,
                        pass: _passController.text,
                        onSucess: _onSucess,
                        onFail: _onFail,
                      );
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

  void _onSucess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Falha ao entrar'),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
