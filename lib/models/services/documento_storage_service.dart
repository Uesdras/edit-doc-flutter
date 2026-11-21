import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../documento.dart';

class DocumentoStorageService {
  static const _chave = 'documentos';

  // READ
  Future<List<Documento>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_chave);
    if (texto == null || texto.isEmpty) return [];
    final List<dynamic> lista = jsonDecode(texto) as List<dynamic>;
    return lista
        .map((e) => Documento.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _salvarLista(List<Documento> docs) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(docs.map((d) => d.toMap()).toList());
    await prefs.setString(_chave, texto);
  }

  // CREATE
  Future<void> criar(Documento doc) async {
    final lista = await listar();
    lista.add(doc);
    await _salvarLista(lista);
  }

  // UPDATE
  Future<void> atualizar(Documento doc) async {
    final lista = await listar();
    final indice = lista.indexWhere((d) => d.id == doc.id);
    if (indice == -1) return;
    lista[indice] = doc;
    await _salvarLista(lista);
  }

  // DELETE
  Future<void> excluir(String id) async {
    final lista = await listar();
    lista.removeWhere((d) => d.id == id);
    await _salvarLista(lista);
  }
}
