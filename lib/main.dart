import 'package:flutter/material.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/documentos_viewmodel.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'views/editor_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authViewModel = AuthViewModel();
  final documentosViewModel = DocumentosViewModel();

  // Restaura os dados salvos antes de abrir a tela
  await authViewModel.carregarSessao();
  await documentosViewModel.carregar();

  runApp(MeuApp(
    authViewModel: authViewModel,
    documentosViewModel: documentosViewModel,
  ));
}

class MeuApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  const MeuApp({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DocEditor MVVM',
          theme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          themeMode: authViewModel.temaEscolhido == 'Escuro'
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: authViewModel.logado ? '/home' : '/',
          routes: {
            '/': (context) => LoginView(viewModel: authViewModel),
            '/cadastro': (context) => CadastroView(viewModel: authViewModel),
            '/home': (context) => HomeView(
                  viewModel: authViewModel,
                  documentosViewModel: documentosViewModel,
                ),
            '/editor': (context) => EditorView(viewModel: documentosViewModel),
          },
        );
      },
    );
  }
}
