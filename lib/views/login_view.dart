import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController identificacaoController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final AuthService authService = AuthService();

  void _login() async {
    try {
      final user = await authService.login(identificacaoController.text, senhaController.text);
      if (user != null) {
        // Navegue para a tela principal
      }
    } catch (e) {
      print('Erro no login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: identificacaoController,
              decoration: InputDecoration(labelText: 'Identificação'),
            ),
            TextField(
              controller: senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
