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
        print('Erro ao cadastrar: $e');
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
