class PrevisaoHora {
  final String horario;
  final String descricao;
  final int numeroIcone;
  final double temperatura;

  PrevisaoHora(
    this.horario,
    this.descricao,
    this.numeroIcone,
    this.temperatura,
  );

  factory PrevisaoHora.transformarJSON(Map<String, dynamic> objJson) {
    return PrevisaoHora(
        PrevisaoHora.transformarHorario(objJson['DateTime']),
        objJson['IconPhrase'],
        objJson['WeatherIcon'],
        objJson['Temperature']['Value']);
  }

  static String transformarHorario(String horario) {
    return horario != null ? horario.split('T')[1].substring(0, 5) : '';
  }
}
