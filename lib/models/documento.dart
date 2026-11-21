class Documento {
  final String id;
  final String titulo;
  final String conteudo;
  final DateTime atualizadoEm;

  Documento({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.atualizadoEm,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'conteudo': conteudo,
        'atualizadoEm': atualizadoEm.toIso8601String(),
      };

  factory Documento.fromMap(Map<String, dynamic> map) => Documento(
        id: map['id'] as String,
        titulo: map['titulo'] as String,
        conteudo: map['conteudo'] as String,
        atualizadoEm: DateTime.parse(map['atualizadoEm'] as String),
      );
}
