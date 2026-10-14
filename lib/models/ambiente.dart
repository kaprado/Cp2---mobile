
class Ambiente {
  String nome;
  int _capacidadeMaxima;
  String imagemAsset;

  Ambiente({
    required this.nome,
    required int capacidadeMaxima,
    required this.imagemAsset,
  }) : _capacidadeMaxima = capacidadeMaxima;

  Ambiente.academia()
      : nome = 'Academia FitZone',
        _capacidadeMaxima = 50,
        imagemAsset = 'assets/academia.png';

  int get capacidadeMaxima => _capacidadeMaxima;

  set capacidadeMaxima(int novaCapacidade) {
    if (novaCapacidade > 0) {
      _capacidadeMaxima = novaCapacidade;
    }
  }

  String descricao() {
    return '$nome — capacidade máxima de $_capacidadeMaxima pessoas';
  }
}
