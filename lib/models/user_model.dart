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
