import 'package:flutter_test/flutter_test.dart';

import 'package:controle_lotacao_academia/models/pessoa.dart';

void main() {
  test('Pessoa começa no ambiente e só pode sair uma vez', () {
    final pessoa = Pessoa(
      nome: 'Maria Silva',
      identificacao: '123456',
      dataEntrada: DateTime(2026, 9, 30, 19, 35),
    );

    expect(pessoa.noAmbiente, isTrue);
    expect(pessoa.situacao, 'No ambiente');

    expect(pessoa.registrarSaida(), isTrue);
    expect(pessoa.noAmbiente, isFalse);
    expect(pessoa.situacao, 'Saiu');
    expect(pessoa.dataSaida, isNotNull);

    expect(pessoa.registrarSaida(), isFalse);
  });
}
