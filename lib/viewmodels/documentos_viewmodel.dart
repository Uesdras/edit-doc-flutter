import 'package:flutter/foundation.dart';
import '../models/documento.dart';
import '../models/services/documento_storage_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  final DocumentoStorageService _storage = DocumentoStorageService();

  List<Documento> _documentos = [];
  bool _carregando = false;

  List<Documento> get documentos => List.unmodifiable(_documentos);
  bool get carregando => _carregando;

  Future<void> carregar() async {
    _carregando = true;
    notifyListeners();

    final lista = await _storage.listar();
    lista.sort((a, b) => b.atualizadoEm.compareTo(a.atualizadoEm));
    _documentos = lista;

    _carregando = false;
    notifyListeners();
  }

  // Cria (id == null) ou edita (id existente)
  Future<void> salvar({
    String? id,
    required String titulo,
    required String conteudo,
  }) async {
    final doc = Documento(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: titulo,
      conteudo: conteudo,
      atualizadoEm: DateTime.now(),
    );

    if (id == null) {
      await _storage.criar(doc);
    } else {
      await _storage.atualizar(doc);
    }
    await carregar();
  }

  Future<void> excluir(String id) async {
    await _storage.excluir(id);
    await carregar();
  }
}
