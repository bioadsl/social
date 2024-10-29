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
