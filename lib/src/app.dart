import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucas_app/classes/produtos.dart';
import 'package:lucas_app/globalvar/variaveis.dart';
import 'package:lucas_app/src/edit_item_page.dart';
import 'package:lucas_app/src/edit_item_page_pc.dart';
import 'package:lucas_app/widgets/item_produto.dart';
import 'package:money2/money2.dart';

import 'add_item_page.dart';
import 'carrinho.dart';

final real = Currency.create('Real', 2,
    symbol: 'R\$', invertSeparators: true, pattern: 'S #.##0,00');

double valorCarrinho = 0;

List<Produto> prod = [];

class MainAppPage extends StatefulWidget {
  const MainAppPage({Key? key}) : super(key: key);

  @override
  _MainAppPageState createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  int _tiposIndex = 0;

  final Stream<QuerySnapshot> _produtosStream = FirebaseFirestore.instance
      .collection('produtos')
      .orderBy('nome')
      .snapshots();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final txtControlTipo = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<Produto> listaDeProdutos = <Produto>[];
  late List<String> _tipos = ['TODOS'];

  Widget _buildChoiceChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tipos.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(_tipos[index]),
              selected: _tiposIndex == index,
              selectedColor: const Color.fromARGB(100, 153, 250, 153),
              onSelected: (bool selected) {
                setState(() {
                  _tiposIndex = selected ? index : 0;
                });
              },
              //backgroundColor: Colors.green,
              labelStyle: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Future<void> listarTipos() async {
    //final snapshot = await firestore.collection('produtos').get();

    CollectionReference _produtos =
        FirebaseFirestore.instance.collection('produtos');

    _produtos.get().then((value) {
      final map = value.docs.toList();

      map.forEach((element) {
        _tipos.add(element['tipo']);
      });
      _tipos.toSet();

      var distinctIds = _tipos.toSet().toList();

      _tipos = distinctIds;

      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    listarTipos();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Tabacaria Strong'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CarrinhoWidget(
                            produtos: carrinho,
                          )),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.shoppingCart))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Image.asset('assets/logostrong.png'),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditItemPagePc(),
                      ));
                },
                child: const ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Editar Produto'),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddItemPage(),
                      ));
                },
                child: const ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Adicionar Produto'),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Valor Total: ${Money.fromNumWithCurrency(valorCarrinho, real)}'),
                  ],
                ),
              ],
            ),
          )),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeAheadFormField(
              hideOnEmpty: true,
              hideOnLoading: true,
              textFieldConfiguration: TextFieldConfiguration(
                  controller: txtControlTipo,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(15, 17, 8, 17),
                      labelText: 'Buscar Produto')),
              suggestionsCallback: (pattern) {
                List<Produto> matches = <Produto>[];

                matches.addAll(prod);

                matches.retainWhere((s) => s.nome
                    .toLowerCase()
                    .contains(txtControlTipo.text.toLowerCase()));

                matches.retainWhere((s) =>
                    s.nome.toLowerCase().contains(pattern.toLowerCase()));
                return matches;
              },
              itemBuilder: (context, Produto suggestion) {
                return Card(
                  child: ListTile(
                    title: Text(suggestion.nome),
                    subtitle: Text(
                        Money.fromNumWithCurrency(suggestion.valorVenda, real)
                            .toString()),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (Produto suggestion) {
                bool existe = false;
                //suggestion.quantidadeCarrinho += 1;

                existe = carrinho.any((element) {
                  if (element.nome == suggestion.nome) {
                    return true;
                  } else {
                    return false;
                  }
                });

                if (existe) {
                  suggestion.quantidadeCarrinho += 1;
                  //listaProdutos.add(suggestion);
                  atualizaCarrinho();
                } else {
                  suggestion.quantidadeCarrinho += 1;
                  carrinho.add(suggestion);
                  atualizaCarrinho();
                }

                txtControlTipo.text = '';

                setState(() {});
              },
              onSaved: (value) => txtControlTipo.text = value.toString(),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Categorias',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ],
          ),
          _buildChoiceChips(),
          Flexible(
            child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _tiposIndex != 0
                      ? firestore
                          .collection('produtos')
                          .where('tipo', isEqualTo: _tipos[_tiposIndex])
                          .snapshots()
                      : firestore
                          .collection('produtos')
                          .orderBy('nome')
                          .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    snapshot.data?.docs.forEach((element) {
                      return prod.add(Produto(
                          nome: element['nome'],
                          estoque: element['estoque'],
                          valorVenda: element['valorVenda'],
                          fornecedor: element['fornecedor'],
                          tipo: element['tipo'],
                          nicotina: element['nicotina'],
                          mgNicotina: element['mgNicotina'],
                          valorEstoque: element['valorEstoque']));
                    });

                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Text('Algo deu Errado');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Carregando"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }
                    //GridView

                    return GridView.extent(
                      maxCrossAxisExtent: 300,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return itemProduto(
                            data['nome'],
                            data['fornecedor'],
                            data['linkImagem'],
                            Money.fromNumWithCurrency(data['valorVenda'], real)
                                .toString());
                      }).toList(),
                    );
                  },
                )),
          )
        ],
      ),
    );
  }

  void atualizaCarrinho() {
    valorCarrinho = 0;
    for (var element in carrinho) {
      valorCarrinho += (element.valorVenda * element.quantidadeCarrinho);
    }
  }

  Widget cardButton(String textoCartao, String textoTipo) {
    double borderRadius = 24;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color.fromARGB(75, 139, 195, 74),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Color.fromARGB(255, 153, 250, 153),
            width: 0,
          ),
        ),
        child: InkWell(
          //splashColor: Color.fromARGB(255, 255, 0, 0),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          onTap: () {
            listaDeProdutos.clear();
            for (var element in prod) {
              if (element.tipo == textoTipo) {
                listaDeProdutos.add(element);
              }
            }
            if (textoTipo == 'todos') {
              for (var element in prod) {
                listaDeProdutos.add(element);
              }
            }
            setState(() {});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.abc, size: 48,
                //color: Colors.black,
              ),
              Text(
                textoCartao,
                maxLines: 2,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
