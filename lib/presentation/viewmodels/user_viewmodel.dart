import 'package:app_loja/data/repository/user_repository.dart';
import 'package:flutter/widgets.dart';

class UserViewmodel with ChangeNotifier {
  final UserRepository _userRepository;

  String? _token;
  String? _username;
  String? _errorMessage; // Corrigido de _erroMessage para _errorMessage
  bool _isLoading = false;

  UserViewmodel(this._userRepository);

  String? get token => _token;
  String? get username => _username;
  String? get errorMessage => _errorMessage; // Corrigido para errorMessage
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null;

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _errorMessage =
          'Username or password cannot be empty.'; // Mensagem de erro caso os campos estejam vazios
      notifyListeners();
      return false;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _token = await _userRepository.login(username, password);
      _username = username;
      _isLoading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      _token = null;
      _username = null;
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _token = null;
    _username = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearErrorMessage() {
    // Corrigido para clearErrorMessage
    _errorMessage = null;
    notifyListeners();
  }
}
