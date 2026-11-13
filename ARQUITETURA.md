# Relatório de Migração Arquitetural (DartPad → MVVM)

Aluno: Uesdras Filho

## 1. Mapeamento de Classes e Widgets

| Elemento no DartPad | Novo local | Camada |
|---|---|---|
| `main()` e `MeuApp` (MaterialApp, tema, rotas nomeadas) | `lib/main.dart` | Ponto de entrada |
| `Usuario` | `lib/models/usuario.dart` | Model |
| `BancoDadosLocal` (renomeada `BancoLocalService`) | `lib/models/services/banco_local_service.dart` | Model (service) |
| `SharedPreferences` simulada (mapa em memória) | Removida. Substituída pelo pacote real `shared_preferences`, encapsulado em `lib/models/services/preferences_service.dart` (`PreferencesService`) | Model (service) |
| `validarNome`, `validarEmail`, `validarSenha` | `lib/utils/validadores.dart` | Utils |
| `TelaLogin` / `_TelaLoginState` | `lib/views/login_view.dart` (`LoginView`) | View |
| `TelaCadastro` / `_TelaCadastroState` | `lib/views/cadastro_view.dart` (`CadastroView`) | View |
| `TelaHome` | `lib/views/home_view.dart` (`HomeView`) | View |
| Lógica de login, cadastro, preferências e listagem de usuários (antes dentro das telas) | `lib/viewmodels/auth_viewmodel.dart` (`AuthViewModel`) | ViewModel |

`documento.dart`, `documentos_viewmodel.dart`, `documento_storage_service.dart` e `editor_view.dart` serão criados na Etapa 5 (CRUD).

## 2. Alterações de Estrutura e Imports

- **Imports:** cada arquivo importa só o que usa, sempre de camadas inferiores. Views importam ViewModels e utils; ViewModels importam models e services; models não importam nada acima. Exemplo: `import '../viewmodels/auth_viewmodel.dart';`.
- **Construtores:** as views passaram a receber o `AuthViewModel` por construtor (`required this.viewModel`), em vez de chamar `BancoDadosLocal` e `SharedPreferences` diretamente. O `MeuApp` também recebe o ViewModel por construtor e deixou de ser `const`.
- **Instância única:** o `AuthViewModel` é criado uma vez em `main()` e compartilhado pelas três rotas.
- **Rotas nomeadas:** continuam em `main.dart` (`/`, `/cadastro`, `/home`), mas agora cada rota instancia a View correspondente passando o ViewModel. O argumento de `/home` (nome do usuário) continua sendo lido com `ModalRoute`.
- **Visibilidade:** as funções de validação continuam públicas (funções de nível de arquivo), agora importadas de `utils/validadores.dart`. `BancoDadosLocal` foi renomeada para `BancoLocalService`, seguindo o nome do roteiro.
- **Pacote real:** a classe `SharedPreferences` simulada foi removida; o pacote `shared_preferences` (adicionado com `flutter pub add`) é importado apenas em `preferences_service.dart`.
- **Contexto assíncrono:** após cada `await`, as views passaram a verificar `mounted` / `context.mounted` antes de usar `Navigator`, `ScaffoldMessenger` ou `showDialog`.
- **Tema:** foi adicionado `darkTheme` e `themeMode` ao `MaterialApp`, para o tema escolhido ser reativo.

## 3. Mudanças no Gerenciamento de Estado

**`setState()` removidos das views:**
- `TelaLogin`: `setState(() => _carregando = true)` e `setState(() => _carregando = false)` em `_fazerLogin`.
- `TelaCadastro`: os dois `setState` de `_carregando` em `_cadastrar`, o `setState` de `_temaEscolhido` (dropdown) e o `setState` de `_notificacoesAtivadas` (switch).
- `TelaHome` já era `StatelessWidget` e continua sem estado.

**Variáveis que passaram para o `AuthViewModel` (`ChangeNotifier`):**
- `_carregando`, `_temaEscolhido` e `_notificacoesAtivadas`, expostas por getters.
- Métodos: `login()`, `cadastrar()`, `alterarTema()`, `alterarNotificacoes()`, `carregarPreferencias()` e `obterUsuarios()`.

**Como as telas reagem:**
- O ViewModel chama `notifyListeners()` sempre que muda `_carregando`, o tema ou as notificações.
- As telas de login e cadastro envolvem a parte reativa em `ListenableBuilder(listenable: viewModel, ...)`, que reconstrói a interface (botão com indicador de carregamento, dropdown, switch) a cada notificação.
- O `MaterialApp` também usa `ListenableBuilder`, então o `themeMode` acompanha o `temaEscolhido`.
- As views mantêm apenas estado puramente visual: `GlobalKey<FormState>` e `TextEditingController`, que não são regra de negócio.
