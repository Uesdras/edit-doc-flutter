String? validarNome(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe o nome completo';
  }
  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe um e-mail válido';
  }
  // Requisito: presença de '@' e terminação obrigatória em '.com' ou '.com.br'
  if (!value.contains('@')) {
    return 'O e-mail deve conter o caractere "@"';
  }
  String lower = value.trim().toLowerCase();
  if (!lower.endsWith('.com') && !lower.endsWith('.com.br')) {
    return 'O e-mail deve terminar com ".com" ou ".com.br"';
  }
  return null;
}

String? validarSenha(String? value) {
  if (value == null || value.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }
  return null;
}
