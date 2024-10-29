#!/bin/bash

# Criar a estrutura de diretórios, se ainda não existir
mkdir -p lib/{models,services,views,widgets}

# Criar o modelo de usuário em lib/models/user_model.dart
cat <<EOL > lib/models/user_model.dart
class User {
  final String id;
  final String nomeCompleto;
  final String dataNascimento;
  final String genero;
  final String estadoCivil;
  final String numeroIdentificacao;
  final String endereco;
  final String telefone;
  final String email;
  final List<Familiar> composicaoFamiliar;
  final double rendaFamiliarTotal;
  final String condicaoMoradia;
  final String situacaoEmprego;
  final String nivelEscolaridade;
  final String necessidadesEspeciais;
  final bool participaOutrosProgramas;
  final String situacaoSaude;

  User({
    required this.id,
    required this.nomeCompleto,
    required this.dataNascimento,
    required this.genero,
    required this.estadoCivil,
    required this.numeroIdentificacao,
    required this.endereco,
    required this.telefone,
    this.email = '',
    required this.composicaoFamiliar,
    required this.rendaFamiliarTotal,
    required this.condicaoMoradia,
    required this.situacaoEmprego,
    required this.nivelEscolaridade,
    this.necessidadesEspeciais = '',
    this.participaOutrosProgramas = false,
    this.situacaoSaude = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var list = json['composicao_familiar'] as List;
    List<Familiar> familiarList = list.map((i) => Familiar.fromJson(i)).toList();

    return User(
      id: json['id'],
      nomeCompleto: json['nome_completo'],
      dataNascimento: json['data_nascimento'],
      genero: json['genero'],
      estadoCivil: json['estado_civil'],
      numeroIdentificacao: json['numero_identificacao'],
      endereco: json['endereco'],
      telefone: json['telefone'],
      email: json['email'] ?? '',
      composicaoFamiliar: familiarList,
      rendaFamiliarTotal: json['renda_familiar_total'],
      condicaoMoradia: json['condicao_moradia'],
      situacaoEmprego: json['situacao_emprego'],
      nivelEscolaridade: json['nivel_escolaridade'],
      necessidadesEspeciais: json['necessidades_especiais'] ?? '',
      participaOutrosProgramas: json['participa_outros_programas'] ?? false,
      situacaoSaude: json['situacao_saude'] ?? '',
    );
  }
}

class Familiar {
  final String nome;
  final String grauParentesco;

  Familiar({
    required this.nome,
    required this.grauParentesco,
  });

  factory Familiar.fromJson(Map<String, dynamic> json) {
    return Familiar(
      nome: json['nome'],
      grauParentesco: json['grau_parentesco'],
    );
  }
}
EOL

# Criar o serviço de usuário em lib/services/user_service.dart
cat <<EOL > lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  final String baseUrl = 'http://localhost:3000/users'; // Ajuste para a URL da sua API

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar usuários');
    }
  }

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome_completo': user.nomeCompleto,
        'data_nascimento': user.dataNascimento,
        'genero': user.genero,
        'estado_civil': user.estadoCivil,
        'numero_identificacao': user.numeroIdentificacao,
        'endereco': user.endereco,
        'telefone': user.telefone,
        'email': user.email,
        'composicao_familiar': user.composicaoFamiliar.map((f) => {
          'nome': f.nome,
          'grau_parentesco': f.grauParentesco,
        }).toList(),
        'renda_familiar_total': user.rendaFamiliarTotal,
        'condicao_moradia': user.condicaoMoradia,
        'situacao_emprego': user.situacaoEmprego,
        'nivel_escolaridade': user.nivelEscolaridade,
        'necessidades_especiais': user.necessidadesEspeciais,
        'participa_outros_programas': user.participaOutrosProgramas,
        'situacao_saude': user.situacaoSaude,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao criar usuário');
    }
  }
}
EOL

# Criar a View de Cadastro em lib/views/registration_view.dart
cat <<EOL > lib/views/registration_view.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class RegistrationView extends StatefulWidget {
  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final UserService userService = UserService();
  final _formKey = GlobalKey<FormState>();
  late User newUser;

  // Inicializando com valores padrão
  @override
  void initState() {
    super.initState();
    newUser = User(
      id: '',
      nomeCompleto: '',
      dataNascimento: '',
      genero: '',
      estadoCivil: '',
      numeroIdentificacao: '',
      endereco: '',
      telefone: '',
      email: '',
      composicaoFamiliar: [],
      rendaFamiliarTotal: 0.0,
      condicaoMoradia: '',
      situacaoEmprego: '',
      nivelEscolaridade: '',
      necessidadesEspeciais: '',
      participaOutrosProgramas: false,
      situacaoSaude: '',
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await userService.createUser(newUser);
        // Navegar ou mostrar uma mensagem de sucesso
      } catch (e) {
        print('Erro ao cadastrar: \$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome Completo'),
                onChanged: (value) => newUser.nomeCompleto = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome completo.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Data de Nascimento'),
                onChanged: (value) => newUser.dataNascimento = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de nascimento.';
                  }
                  return null;
                },
              ),
              // Adicione mais campos conforme necessário...
              ElevatedButton(
                onPressed: _submit,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
EOL

# Criar a View de Login em lib/views/login_view.dart
cat <<EOL > lib/views/login_view.dart
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
      print('Erro no login: \$e');
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
EOL

echo "Estrutura e classes Flutter criadas com sucesso em 'social'."
