import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();

  bool _carregando = false;
  String _temaEscolhido = 'Claro';
  bool _notificacoesAtivadas = true;
  String? _nomeUsuario;

  bool get carregando => _carregando;
  String get temaEscolhido => _temaEscolhido;
  bool get notificacoesAtivadas => _notificacoesAtivadas;
  String? get nomeUsuario => _nomeUsuario;
  bool get logado => _nomeUsuario != null;

  // Chamado em main() antes do runApp: restaura tema e sessão salvos
  Future<void> carregarSessao() async {
    _temaEscolhido = await _prefsService.lerTema() ?? 'Claro';
    _notificacoesAtivadas = await _prefsService.lerNotificacoes() ?? true;
    _nomeUsuario = await _prefsService.lerSessaoNome();
    notifyListeners();
  }

  void alterarTema(String tema) {
    _temaEscolhido = tema;
    _prefsService.salvarTema(tema);
    notifyListeners();
  }

  void alterarNotificacoes(bool valor) {
    _notificacoesAtivadas = valor;
    _prefsService.salvarNotificacoes(valor);
    notifyListeners();
  }

  Future<Usuario?> login(String email, String senha) async {
    _carregando = true;
    notifyListeners();

    final usuario = await BancoLocalService.autenticar(email, senha);
    if (usuario != null) {
      _nomeUsuario = usuario.nome;
      await _prefsService.salvarSessao(usuario.nome, usuario.email);
    }

    _carregando = false;
    notifyListeners();
    return usuario;
  }

  Future<void> logout() async {
    _nomeUsuario = null;
    await _prefsService.limparSessao();
    notifyListeners();
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
