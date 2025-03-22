class Produto {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String imageUrl;
  final int estoque;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imageUrl,
    required this.estoque,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] ?? 0, //Valor padrão para o ID
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      preco: double.tryParse(json['preco'].toString()) ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      estoque: json['estoque'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Produto(id: $id, nome: $nome, descricao: $descricao, preco: $preco, imagemUrl: $imageUrl, estoque: $estoque)';
  }
}
