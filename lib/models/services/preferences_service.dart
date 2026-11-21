import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _chaveTema = 'tema_app';
  static const _chaveNotificacoes = 'notificacoes';
  static const _chaveSessaoNome = 'sessao_nome';
  static const _chaveSessaoEmail = 'sessao_email';

  Future<void> salvarTema(String tema) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveTema, tema);
  }

  Future<void> salvarNotificacoes(bool ativadas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveNotificacoes, ativadas);
  }

  Future<String?> lerTema() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chaveTema);
  }

  Future<bool?> lerNotificacoes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveNotificacoes);
  }

  // Sessão do usuário logado
  Future<void> salvarSessao(String nome, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveSessaoNome, nome);
    await prefs.setString(_chaveSessaoEmail, email);
  }

  Future<String?> lerSessaoNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chaveSessaoNome);
  }

  Future<void> limparSessao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveSessaoNome);
    await prefs.remove(_chaveSessaoEmail);
  }
}
