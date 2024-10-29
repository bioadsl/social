#!/bin/bash

# Criação da estrutura de pastas
mkdir -p lib/{models,services,views,controllers,widgets}

# Criação do arquivo principal para rotas
cat <<EOL > lib/main.dart
import 'package:flutter/material.dart';
import 'package:social/views/login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serviço Social',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(),
    );
  }
}
EOL

# Criação de modelo de usuário em lib/models/user_model.dart
cat <<EOL > lib/models/user_model.dart
class User {
  final String id;
  final String nomeCompleto;
  final String dataNascimento;
  final String genero;

  User({required this.id, required this.nomeCompleto, required this.dataNascimento, required this.genero});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nomeCompleto: json['nome_completo'],
      dataNascimento: json['data_nascimento'],
      genero: json['genero'],
    );
  }
}
EOL

# Criação do serviço de autenticação em lib/services/auth_service.dart
cat <<EOL > lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3000';

  Future<User?> login(String identificacao, String senha) async {
    final response = await http.post(
   
