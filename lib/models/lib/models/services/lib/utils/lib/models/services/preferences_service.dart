import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _chaveTema = 'tema_app';
  static const _chaveNotificacoes = 'notificacoes';

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
}
