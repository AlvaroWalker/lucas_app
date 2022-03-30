class Produto {
  String nome;
  int estoque;
  double valorVenda;
  String fornecedor;
  String tipo;
  bool nicotina;
  double mgNicotina;
  double valorEstoque;
  int quantidadeCarrinho;
  String linkImagem;

  Produto(
      {required this.nome,
      required this.estoque,
      required this.valorVenda,
      required this.fornecedor,
      required this.tipo,
      required this.nicotina,
      required this.mgNicotina,
      required this.valorEstoque,
      this.quantidadeCarrinho = 0,
      this.linkImagem = 'https://sindilojaslc.com.br/Imagens/img.jpg'});
}
