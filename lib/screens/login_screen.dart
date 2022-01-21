import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          TextButton(
            onPressed: () {},
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Email',
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
              decoration: const InputDecoration(
                hintText: 'Senha',
              ),
              obscureText: true,
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
                onPressed: () {
                  if (_formKey.currentState.validate()) {}
                },
                child: const Text(
                  'Entrar',
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
