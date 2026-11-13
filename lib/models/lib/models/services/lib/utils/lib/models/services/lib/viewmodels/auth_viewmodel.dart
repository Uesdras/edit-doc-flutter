import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();

  bool _carregando = false;
  String _temaEscolhido = 'Claro';
  bool _notificacoesAtivadas = true;

  bool get carregando => _carregando;
  String get temaEscolhido => _temaEscolhido;
  bool get notificacoesAtivadas => _notificacoesAtivadas;

  void alterarTema(String tema) {
    _temaEscolhido = tema;
    notifyListeners();
  }

  void alterarNotificacoes(bool valor) {
    _notificacoesAtivadas = valor;
    notifyListeners();
  }

  Future<Usuario?> login(String email, String senha) async {
    _carregando = true;
    notifyListeners();

    final usuario = await BancoLocalService.autenticar(email, senha);

    _carregando = false;
    notifyListeners();
    return usuario;
  }

  Future<bool> cadastrar(Usuario novoUsuario) async {
    _carregando = true;
    notifyListeners();

    await _prefsService.salvarTema(_temaEscolhido);
    await _prefsService.salvarNotificacoes(_notificacoesAtivadas);

    final sucesso = await BancoLocalService.cadastrarUsuario(novoUsuario);

    _carregando = false;
    notifyListeners();
    return sucesso;
  }

  Future<Map<String, dynamic>> carregarPreferencias() async {
    final tema = await _prefsService.lerTema() ?? 'Não definido';
    final notificacoes = await _prefsService.lerNotificacoes() ?? false;
    return {'tema': tema, 'notificacoes': notificacoes};
  }

  Future<List<Usuario>> obterUsuarios() {
    return BancoLocalService.obterTodosUsuarios();
  }
}
