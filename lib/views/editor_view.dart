import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../viewmodels/documentos_viewmodel.dart';

class EditorView extends StatefulWidget {
  final DocumentosViewModel viewModel;
  const EditorView({super.key, required this.viewModel});

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _conteudoController = TextEditingController();
  Documento? _documento;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iniciado) {
      _documento = ModalRoute.of(context)?.settings.arguments as Documento?;
      _tituloController.text = _documento?.titulo ?? '';
      _conteudoController.text = _documento?.conteudo ?? '';
      _iniciado = true;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    await widget.viewModel.salvar(
      id: _documento?.id,
      titulo: _tituloController.text.trim(),
      conteudo: _conteudoController.text,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = _documento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar Documento' : 'Novo Documento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return Column(
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o título do documento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _conteudoController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        labelText: 'Conteúdo',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: widget.viewModel.carregando ? null : _salvar,
                      icon: const Icon(Icons.save),
                      label: Text(
                          editando ? 'Salvar alterações' : 'Criar documento'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
