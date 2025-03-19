import 'package:app_loja/data/model/produto_model.dart';
import 'package:app_loja/data/repository/produto_repository.dart';
import 'package:flutter/material.dart';

class ProdutoViewmodel with ChangeNotifier {
  final ProdutoRepository _produtoRepository;
  List<Produto> _produtos = [];
  final List<Produto> _carrinho = [];
  bool _isLoading = false;
  bool _isLoadingMore = false; // Indica se esta carregando mais produtos
  String? _token;
  String? _username;
  String? _errorMessage;

  int _paginaAtual = 1; //Pagina inicial
  bool _temMaisPaginas = true; // Indica se ha mais paginas para carregar
  int _totalPaginas =
      1; // Total de apginas, ajustado conforme a resposta da API

  ProdutoViewmodel(this._produtoRepository);

  List<Produto> get produtos => _produtos;
  List<Produto> get carrinho => _carrinho;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => isLoadingMore;
  bool get isLoggediIn => _token != null;
  String? get username => _username;
  String? get errorMessage => _errorMessage;
  bool get temMaisPaginas => _temMaisPaginas;
  int get paginaAtual => _paginaAtual;
  int get totalPaginas => _totalPaginas;

  /// ** Carrega os produtos inicias**
  Future<void> carregarProdutos() async {
    _isLoading = true;
    _paginaAtual = 1;
    _temMaisPaginas = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var resposta = await _produtoRepository.fetchProdutos(page: _paginaAtual);
      _produtos = resposta['produtos'];

      //Verifica se ha mais paginas
      _temMaisPaginas = resposta['nextPage'] != null;

      //Calcula o total de paginas (10 produtos por pagina)
      int count = resposta['count'];
      int produtosPorPagina = 10;
      _totalPaginas = (count / produtosPorPagina).ceil();
    } catch (e) {
      print(e);
      _errorMessage = 'Erro ao carregar produtos: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ** Carrega mais produtos conforme a paginação**
  Future<void> carregarPagina(int pagina) async {
    _produtos = [];
    print('Carregando pagina: $pagina');
    if (pagina <= 0 || pagina > totalPaginas || _isLoadingMore) return;

    _paginaAtual = pagina;
    _isLoadingMore = true;
    notifyListeners();

    try {
      var resposta = await _produtoRepository.fetchProdutos(page: _paginaAtual);
      print('Produtos carregados: ${resposta['produtos']}');
      if (pagina == 1) {
        _produtos = resposta['produtos'];
      } else {
        _produtos.addAll(resposta['produtos']);
      }
      _temMaisPaginas = resposta['nextPage'] != null;
      print('Tem mais paginas: $_temMaisPaginas');
    } catch (e) {
      _errorMessage = 'Erro ao caregar produtos $e';
      print(_errorMessage);
    }

    _isLoadingMore = false;
    notifyListeners();
  }
}
