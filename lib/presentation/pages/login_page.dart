import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State {
  final usernameController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future login() async {
    final viewModel = Provider.of(context, listen: false);
    final username = usernameController.text;
    final senha = senhaController.text; // Corrigido para obter o texto

    if (username.isEmpty || senha.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Por favor, preencha todos os campos")),
        );
      }
      return;
    }

    try {
      bool sucesso = await viewModel.login(username, senha); // Passando a senha
      if (mounted && sucesso) {
        Navigator.pushReplacementNamed(context, "/");
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro ao fazer login. Verifique as credenciais."),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao fazer login: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Nome de Usuário",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: senhaController,
              decoration: InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Para ocultar a senha
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: login, child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
