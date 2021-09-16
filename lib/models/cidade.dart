class Cidade {
  String codigo = '';
  final String nome;
  final String estado;
  final String siglaEstado;

  Cidade(this.nome, this.estado, this.siglaEstado);
  Cidade.comCodigo(this.codigo, this.nome, this.estado, this.siglaEstado);

  factory Cidade.transformarJSON(Map<String, dynamic> objJson) {
    return Cidade.comCodigo(
        objJson['Key'],
        objJson['LocalizedName'],
        objJson['AdministrativeArea']['LocalizedName'],
        objJson['AdministrativeArea']['ID']);
  }

  @override
  String toString() {
    return 'Cidade{id: 1, codigo: $codigo, nome: $nome, estado: $estado, siglaEstado: $siglaEstado}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'codigo': codigo,
      'nome': nome,
      'estado': estado,
      'siglaEstado': siglaEstado
    };
  }
}
