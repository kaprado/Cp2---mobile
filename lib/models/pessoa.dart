class Pessoa {
  String nome;
  String identificacao;
  DateTime dataEntrada;
  DateTime? dataSaida;

  Pessoa({
    required this.nome,
    required this.identificacao,
    required this.dataEntrada,
    this.dataSaida,
  });

  bool get noAmbiente => dataSaida == null;

  String get situacao => noAmbiente ? 'No ambiente' : 'Saiu';

  bool registrarSaida() {
    if (!noAmbiente) return false;
    dataSaida = DateTime.now();
    return true;
  }
}
