import 'package:flutter/material.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';

void main() {
  final authViewModel = AuthViewModel();
  runApp(MeuApp(authViewModel: authViewModel));
}

class MeuApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  const MeuApp({super.key, required this.authViewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sistema Mobile com Persistência',
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
          initialRoute: '/',
          routes: {
            '/': (context) => LoginView(viewModel: authViewModel),
            '/cadastro': (context) => CadastroView(viewModel: authViewModel),
            '/home': (context) => HomeView(viewModel: authViewModel),
          },
        );
      },
    );
  }
}
