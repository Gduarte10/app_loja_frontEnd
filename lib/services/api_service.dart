import 'dart:convert';
import 'package:app_loja/data/model/produto_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api/';

  Future<Map<String, dynamic>> getProdutos({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/produtos/?page=$page'));

    if (response.statusCode == 200) {
      String decodedBody = utf8.decode(
        response.bodyBytes,
      ); // Garante a decodificação correta
      Map<String, dynamic> data = json.decode(decodedBody);

      List<Produto> produtos =
          (data['results'] as List)
              .map((json) => Produto.fromJson(json))
              .toList();

      return {
        'produtos': produtos,
        'count': data['count'],
        'nextPage': data['next'], // URL da próxima página
        'previousPage': data['previus'], //URL da página anterior
      };
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }
}
