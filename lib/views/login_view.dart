import 'package:flutter/material.dart';
import '../utils/validadores.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginView extends StatefulWidget {
  final AuthViewModel viewModel;
  const LoginView({super.key, required this.viewModel});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final usuarioLogado = await widget.viewModel.login(
      _emailController.text.trim(),
      _senhaController.text,
    );

    if (!mounted) return;

    if (usuarioLogado != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha incorretos! Verifique seus dados.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acesso ao Sistema')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline,
                          size: 64, color: Colors.indigo),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
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
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: validarSenha,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                              widget.viewModel.carregando ? null : _fazerLogin,
                          child: widget.viewModel.carregando
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Entrar',
                                  style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/cadastro');
                        },
                        child: const Text('Não tem uma conta? Cadastre-se'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
