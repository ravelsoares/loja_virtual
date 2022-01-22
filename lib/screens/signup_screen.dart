import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  TextEditingController senha = TextEditingController();
  TextEditingController csenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextFormField(
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
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
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
              controller: senha,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              // ignore: missing_return
              validator: (text) {
                if (senha.text.isEmpty || senha.text.length < 6) {
                  return 'A senha precisa ter mais de 6 digitos';
                }
              },
              focusNode: FocusNode(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: csenha,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                labelText: 'Confirme a Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              // ignore: missing_return
              validator: (text) {
                if (csenha.text.isEmpty || csenha.text.length < 6) {
                  return 'A senha precisa ter mais de 6 digitos';
                } else if (csenha.text != senha.text) {
                  return 'As senhas estão diferentes';
                }
              },
              focusNode: FocusNode(),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 44,
              child: TextButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {}
                },
                child: const Text(
                  'Criar Conta',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
