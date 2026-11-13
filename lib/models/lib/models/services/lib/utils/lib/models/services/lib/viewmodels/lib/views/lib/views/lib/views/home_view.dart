import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../viewmodels/auth_viewmodel.dart';

class HomeView extends StatelessWidget {
  final AuthViewModel viewModel;
  const HomeView({super.key, required this.viewModel});

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

  @override
  Widget build(BuildContext context) {
    final String nomeUsuario =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Visitante';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, $nomeUsuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Painel de Controle e Dados',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 3,
            child: InkWell(
              onTap: () => _mostrarPreferencias(context),
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 40, color: Colors.indigo),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preferências do Usuário',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text('Toque para visualizar tema e configurações'),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 3,
            child: InkWell(
              onTap: () => _mostrarUsuariosBanco(context),
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.storage, size: 40, color: Colors.teal),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuários no Banco Local',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text('Toque para listar os registros da tabela'),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
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
