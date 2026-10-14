import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/pessoa.dart';
import '../theme/cores.dart';

class PessoaItem extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onSaida;
  final VoidCallback onExcluir;

  const PessoaItem({
    super.key,
    required this.pessoa,
    required this.onSaida,
    required this.onExcluir,
  });

  static final DateFormat _formato = DateFormat("dd/MM/yyyy 'às' HH:mm");

  @override
  Widget build(BuildContext context) {
    final bool dentro = pessoa.noAmbiente;
    final Color corSituacao = dentro ? AppCores.verde : AppCores.cinza;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Slidable(
          key: ObjectKey(pessoa),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.55,
            children: [
              SlidableAction(
                onPressed: (_) => onSaida(),
                backgroundColor: AppCores.laranja,
                foregroundColor: Colors.white,
                icon: Icons.logout,
                label: 'SAÍDA',
              ),
              SlidableAction(
                onPressed: (_) => onExcluir(),
                backgroundColor: AppCores.primaria,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'EXCLUIR',
              ),
            ],
          ),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color.alphaBlend(
                    corSituacao.withAlpha(38),
                    Colors.white,
                  ),
                  child: Icon(Icons.fitness_center, color: corSituacao),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pessoa.nome,
                        style: GoogleFonts.oswald(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppCores.texto,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${pessoa.identificacao}',
                        style: const TextStyle(color: AppCores.textoSecundario),
                      ),
                      Text(
                        'Entrada: ${_formato.format(pessoa.dataEntrada)}',
                        style: const TextStyle(color: AppCores.textoSecundario),
                      ),
                      if (pessoa.dataSaida != null)
                        Text(
                          'Saída: ${_formato.format(pessoa.dataSaida!)}',
                          style: const TextStyle(
                            color: AppCores.textoSecundario,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 10, color: corSituacao),
                          const SizedBox(width: 6),
                          Text(
                            'Situação: ${pessoa.situacao}',
                            style: TextStyle(
                              color: corSituacao,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left, color: AppCores.cinza),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
