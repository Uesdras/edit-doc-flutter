import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../utils/validadores.dart';
import '../viewmodels/auth_viewmodel.dart';

class CadastroView extends StatefulWidget {
  final AuthViewModel viewModel;
  const CadastroView({super.key, required this.viewModel});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    final sucesso = await widget.viewModel.cadastrar(
      Usuario(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      ),
    );

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário e preferências cadastrados com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: Este e-mail já está cadastrado no sistema!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return ListView(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome Completo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: validarNome,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail (ex: seu@email.com.br)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: validarEmail,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _senhaController,
                    decoration: const InputDecoration(
                      labelText: 'Senha (mín. 6 caracteres)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: validarSenha,
                  ),
                  const Divider(height: 32, thickness: 1),
                  const Text(
                    'Preferências do Aplicativo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: widget.viewModel.temaEscolhido,
                    decoration: const InputDecoration(
                      labelText: 'Tema do App',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.color_lens),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Claro', child: Text('Tema Claro')),
                      DropdownMenuItem(
                          value: 'Escuro', child: Text('Tema Escuro')),
                    ],
                    onChanged: (value) {
                      if (value != null) widget.viewModel.alterarTema(value);
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Ativar Notificações Push'),
                    subtitle: const Text('Receber alertas de novos documentos'),
                    value: widget.viewModel.notificacoesAtivadas,
                    onChanged: widget.viewModel.alterarNotificacoes,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          widget.viewModel.carregando ? null : _cadastrar,
                      child: widget.viewModel.carregando
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text('Cadastrar',
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
