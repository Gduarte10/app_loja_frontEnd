import 'package:app_loja/services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<String> login(String username, String passaword) async {
    try {
      return await apiService.login(username, passaword);
    } catch (e) {
      throw Exception("Erro ap tentar realizar o login: $e");
    }
  }
}
 //sem user