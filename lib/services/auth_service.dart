import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3000';

  Future<User?> login(String identificacao, String senha) async {
    final response = await http.post(
   
