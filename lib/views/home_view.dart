import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../models/usuario.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class HomeView extends StatelessWidget {
  final AuthViewModel viewModel;
  final DocumentosViewModel documentosViewModel;

  const HomeView({
    super.key,
    required this.viewModel,
    required this.documentosViewModel,
  });

  void _mostrarPreferencias(BuildContext context) async {
    final prefs = await viewModel.carregarPreferencias();
    final String tema = prefs['tema'] as String;
    final bool notificacoes = prefs['notificacoes'] as bool;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preferências do Usuário'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Tema Escolhido: $tema'),
            const SizedBox(height: 8),
            Text('• Notificações Ativadas: ${notificacoes ? 'Sim' : 'Não'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _mostrarUsuariosBanco(BuildContext context) async {
    final List<Usuario> lista = await viewModel.obterUsuarios();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Usuários no Banco Local',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    var u = lista[index];
                    return ListTile(
                      leading: const Icon(Icons.person, color: Colors.indigo),
                      title: Text(u.nome),
                      subtitle: Text(u.email),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmarExclusao(BuildContext context, Documento doc) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir documento'),
        content: Text('Deseja excluir "${doc.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou == true) {
      await documentosViewModel.excluir(doc.id);
    }
  }

  String _formatarData(DateTime d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.day)}/${dois(d.month)}/${d.year} ${dois(d.hour)}:${dois(d.minute)}';
  }

  Widget _cardAtalho({
    required IconData icone,
    required Color cor,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icone, size: 40, color: cor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitulo),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nomeUsuario = viewModel.nomeUsuario ?? 'Visitante';
    final escuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, $nomeUsuario'),
        actions: [
          IconButton(
            icon: Icon(escuro ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Alternar tema',
            onPressed: () => viewModel.alterarTema(
                viewModel.temaEscolhido == 'Escuro' ? 'Claro' : 'Escuro'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await viewModel.logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/editor'),
        icon: const Icon(Icons.add),
        label: const Text('Novo documento'),
      ),
      body: ListenableBuilder(
        listenable: documentosViewModel,
        builder: (context, _) {
          final docs = documentosViewModel.documentos;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            children: [
              const Text(
                'Painel de Controle e Dados',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _cardAtalho(
                icone: Icons.settings,
                cor: Colors.indigo,
                titulo: 'Preferências do Usuário',
                subtitulo: 'Toque para visualizar tema e configurações',
                onTap: () => _mostrarPreferencias(context),
              ),
              const SizedBox(height: 12),
              _cardAtalho(
                icone: Icons.storage,
                cor: Colors.teal,
                titulo: 'Usuários no Banco Local',
                subtitulo: 'Toque para listar os registros da tabela',
                onTap: () => _mostrarUsuariosBanco(context),
              ),
              const SizedBox(height: 24),
              const Text(
                'Meus Documentos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (docs.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                        'Nenhum documento ainda. Toque em "Novo documento".'),
                  ),
                ),
              ...docs.map(
                (doc) => Card(
                  child: ListTile(
                    leading:
                        const Icon(Icons.description, color: Colors.indigo),
                    title: Text(doc.titulo),
                    subtitle: Text(
                      '${doc.conteudo.isEmpty ? '(sem conteúdo)' : doc.conteudo}\n'
                      'Atualizado em ${_formatarData(doc.atualizadoEm)}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    onTap: () =>
                        Navigator.pushNamed(context, '/editor', arguments: doc),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Excluir',
                      onPressed: () => _confirmarExclusao(context, doc),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomAppBar(
        height: 48,
        child: Center(
          child: Text('Desenvolvido por Uesdras Filho'),
        ),
      ),
    );
  }
}
