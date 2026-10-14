# Controle de Lotação 2.0 — Academia FitZone

Projeto avaliativo CP2 — Mobile Application Development (FIAP)

## Descrição
Evolução do app do Checkpoint 01. Além do contador de lotação, agora é possível
**cadastrar as pessoas** que entram na academia, acompanhar quem está dentro ou
já saiu, registrar saídas e excluir registros, sempre respeitando a capacidade
máxima (50 pessoas).

## Ambiente escolhido
Academia (capacidade máxima: 50 pessoas)

## Integrantes
- Arthur Lins Belarmino — RM566845
- Kauan Prado Famelli — RM566990

## Vídeo de demonstração
 https://youtu.be/EAdsI8aZS2Q

## Estrutura do projeto
```
lib/
  main.dart                  -> MaterialApp e tema (Google Fonts)
  models/
    ambiente.dart            -> classe Ambiente (capacidade, nome, imagem)
    pessoa.dart              -> classe Pessoa (nome, ID, entrada, saída)
  screens/
    home_page.dart           -> tela principal, cadastro, regras e diálogos
  theme/
    cores.dart               -> paleta de cores em hexadecimal
  widgets/
    pessoa_item.dart         -> widget personalizado da lista (com Slidable)
assets/
  academia.png               -> imagem do ambiente
  icon/                      -> ícone do app (halter)
```

## Como executar
```
flutter pub get
dart run flutter_launcher_icons   # gera o ícone do app (apenas uma vez)
flutter run
```
> O pacote `google_fonts` baixa as fontes na primeira execução, então o
> aparelho/emulador precisa de internet.

## Requisitos atendidos
- **Cadastro** com `TextField` + `TextEditingController` (nome, ID e data/hora)
- **Lista** com `ListView.builder`
- **Controle de entrada/saída** com atualização de "pessoas no ambiente X / 50"
- **Capacidade máxima**: bloqueia a entrada quando lotado e avisa o usuário
- **Feedback** com `ScaffoldMessenger` + `SnackBar`
- **Widget personalizado** `PessoaItem` (recebe `Pessoa` e funções por parâmetro)
- **Passagem de função** entre widgets (`onSaida` e `onExcluir`)
- **AlertDialog** de confirmação ao registrar saída e ao excluir
- **intl** para formatar datas (`dd/MM/yyyy 'às' HH:mm`)
- **Slidable** com as ações SAÍDA e EXCLUIR funcionais
- **Interface**: `SafeArea`, `Padding`, `SizedBox`, `Center`, `Expanded`, `Icon`,
  cores em hexadecimal e `Google Fonts` (Oswald + Roboto)
- **Launcher icon** (halter) com `flutter_launcher_icons`

## Regras de negócio
1. Não é possível ultrapassar a capacidade máxima.
2. Quem já saiu não pode ter a saída registrada novamente.
3. Nome e identificação são obrigatórios.
4. Não é possível ter duas pessoas **no ambiente** com a mesma identificação
   (quem já saiu pode voltar a entrar com o mesmo ID).
5. Todas as operações mostram feedback via SnackBar.

## Tecnologias/pacotes
- Flutter / Dart
- [intl](https://pub.dev/packages/intl)
- [google_fonts](https://pub.dev/packages/google_fonts)
- [flutter_slidable](https://pub.dev/packages/flutter_slidable)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
