import 'package:app_loja/data/model/produto_model.dart';
import 'package:app_loja/presentation/viewmodels/produto_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Consumer, Provider;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  //int _selectedIndex = 0; // Indice de pagina selecionada

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarProdutos();
    });
  }

  Future<void> _carregarProdutos() async {
    final viewModel = Provider.of<ProdutoViewmodel>(context, listen: false);
    try {
      await viewModel.carregarProdutos();
    } catch (error) {
      // Trate o erro de forma apropiada
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar produto...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildProductList()),
          // _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Consumer<ProdutoViewmodel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (viewModel.errorMessage != null) {
          return Center(
            child: Text(
              viewModel.errorMessage!,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        final produtosFiltrados =
            viewModel.produtos
                .where(
                  (produto) => produto.nome.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
                )
                .toList();

        return produtosFiltrados.isEmpty
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Nenhum Produto Encontrado.',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _carregarProdutos,
                  child: const Text('Recarregar'),
                ),
              ],
            )
            : ListView.builder(
              itemCount: produtosFiltrados.length,
              itemBuilder: (context, index) {
                final produto = produtosFiltrados[index];
                return _buildProductCard(produto, viewModel);
              },
            );
      },
    );
  }

  Widget _buildProductCard(Produto produto, ProdutoViewmodel viewModel) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produto.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          produto.descricao,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'R\$ ${produto.preco.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Comprar'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:
                        produto.imageUrl.isNotEmpty
                            ? Image.network(
                              produto.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.grey,
                                );
                              },
                            )
                            : const Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
