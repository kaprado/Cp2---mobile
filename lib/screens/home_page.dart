import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/ambiente.dart';
import '../models/pessoa.dart';
import '../theme/cores.dart';
import '../widgets/pessoa_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Ambiente ambiente = Ambiente.academia();
  final List<Pessoa> pessoas = [];

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final DateFormat _formato = DateFormat("dd/MM/yyyy 'às' HH:mm");

  @override
  void dispose() {
    nomeController.dispose();
    idController.dispose();
    super.dispose();
  }

  int get pessoasNoAmbiente => pessoas.where((p) => p.noAmbiente).length;

  bool get lotado => pessoasNoAmbiente >= ambiente.capacidadeMaxima;

  double get percentualOcupacao => pessoasNoAmbiente / ambiente.capacidadeMaxima;

  String get mensagemSituacao {
    if (lotado) {
      return 'Ambiente lotado';
    } else if (percentualOcupacao >= 0.8) {
      return 'Atenção: ambiente quase cheio';
    } else {
      return 'Pode entrar';
    }
  }

  Color get corSituacao {
    if (lotado) {
      return AppCores.primaria;
    } else if (percentualOcupacao >= 0.8) {
      return AppCores.laranja;
    } else {
      return AppCores.verde;
    }
  }

  void mostrarMensagem(String texto, {bool erro = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: erro ? AppCores.primariaEscura : AppCores.verde,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void abrirCadastro() {
    if (lotado) {
      mostrarMensagem(
        'Não é possível realizar a entrada. Ambiente lotado!',
        erro: true,
      );
      return;
    }

    nomeController.clear();
    idController.clear();
    String? erroNome;
    String? erroId;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            void cadastrar() {
              final nome = nomeController.text.trim();
              final id = idController.text.trim();

              setSheet(() {
                erroNome = nome.isEmpty ? 'Informe o nome da pessoa' : null;
                erroId = id.isEmpty ? 'Informe a identificação' : null;
              });
              if (nome.isEmpty || id.isEmpty) return;

              if (lotado) {
                Navigator.pop(sheetContext);
                mostrarMensagem(
                  'Não é possível realizar a entrada. Ambiente lotado!',
                  erro: true,
                );
                return;
              }

              final duplicado = pessoas.any(
                (p) =>
                    p.noAmbiente &&
                    p.identificacao.toLowerCase() == id.toLowerCase(),
              );
              if (duplicado) {
                setSheet(() {
                  erroId = 'Já existe uma pessoa no ambiente com este ID';
                });
                return;
              }

              setState(() {
                pessoas.insert(
                  0,
                  Pessoa(
                    nome: nome,
                    identificacao: id,
                    dataEntrada: DateTime.now(),
                  ),
                );
              });
              Navigator.pop(sheetContext);
              mostrarMensagem('Pessoa cadastrada com sucesso!');
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'NOVA ENTRADA',
                        style: GoogleFonts.oswald(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppCores.primaria,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nomeController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Nome da pessoa',
                          errorText: erroNome,
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: idController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Identificação / matrícula',
                          errorText: erroId,
                          prefixIcon: const Icon(Icons.badge),
                          border: const OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => cadastrar(),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: AppCores.textoSecundario,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Data e hora do cadastro: '
                              '${_formato.format(DateTime.now())} '
                              '(registrada automaticamente)',
                              style: const TextStyle(
                                color: AppCores.textoSecundario,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: cadastrar,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppCores.primaria,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.login),
                        label: const Text(
                          'CADASTRAR ENTRADA',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _confirmar({
    required String titulo,
    required String mensagem,
  }) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('CANCELAR'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppCores.primaria),
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );
    return resultado == true;
  }

  Future<void> registrarSaida(Pessoa pessoa) async {
    if (!pessoa.noAmbiente) {
      mostrarMensagem('${pessoa.nome} já registrou a saída.', erro: true);
      return;
    }

    final confirmou = await _confirmar(
      titulo: 'Registrar saída?',
      mensagem: 'Deseja realmente registrar a saída de ${pessoa.nome}?',
    );
    if (!confirmou || !mounted) return;

    setState(() => pessoa.registrarSaida());
    mostrarMensagem('Saída registrada com sucesso!');
  }

  Future<void> excluirPessoa(Pessoa pessoa) async {
    final confirmou = await _confirmar(
      titulo: 'Excluir registro?',
      mensagem: pessoa.noAmbiente
          ? 'Deseja realmente excluir o registro de ${pessoa.nome}? '
              'Ela ainda está no ambiente e deixará de ser contada.'
          : 'Deseja realmente excluir o registro de ${pessoa.nome}?',
    );
    if (!confirmou || !mounted) return;

    setState(() => pessoas.remove(pessoa));
    mostrarMensagem('Registro excluído com sucesso!');
  }

  Widget _painelLotacao() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  ambiente.imagemAsset,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pessoas no ambiente',
                      style: TextStyle(color: AppCores.textoSecundario),
                    ),
                    Text(
                      '$pessoasNoAmbiente / ${ambiente.capacidadeMaxima}',
                      style: GoogleFonts.oswald(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppCores.texto,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: percentualOcupacao.clamp(0.0, 1.0),
                        minHeight: 8,
                        color: corSituacao,
                        backgroundColor: const Color(0xFFE0E0E0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Color.alphaBlend(corSituacao.withAlpha(38), Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 18, color: corSituacao),
                const SizedBox(width: 8),
                Text(
                  mensagemSituacao,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: corSituacao,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaVazia() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fitness_center, size: 56, color: AppCores.cinza),
            SizedBox(height: 12),
            Text(
              'Nenhuma pessoa cadastrada.\nToque em "NOVA ENTRADA" para começar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppCores.textoSecundario),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fitness_center),
            const SizedBox(width: 10),
            Text(
              ambiente.nome.toUpperCase(),
              style: GoogleFonts.oswald(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppCores.primaria,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirCadastro,
        backgroundColor: AppCores.primaria,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text(
          'NOVA ENTRADA',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              _painelLotacao(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'PESSOAS CADASTRADAS',
                    style: GoogleFonts.oswald(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppCores.texto,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.swipe_left,
                    size: 16,
                    color: AppCores.textoSecundario,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Deslize para SAÍDA / EXCLUIR',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppCores.textoSecundario,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: pessoas.isEmpty
                    ? _listaVazia()
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 90),
                        itemCount: pessoas.length,
                        itemBuilder: (context, index) {
                          final pessoa = pessoas[index];
                          return PessoaItem(
                            pessoa: pessoa,
                            onSaida: () => registrarSaida(pessoa),
                            onExcluir: () => excluirPessoa(pessoa),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
