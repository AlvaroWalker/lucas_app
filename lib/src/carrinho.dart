import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_network/image_network.dart';
import 'package:lucas_app/src/app.dart';
import 'package:money2/money2.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/produtos.dart';
import '../globalvar/variaveis.dart';

final real = Currency.create('Real', 2,
    symbol: 'R\$', invertSeparators: true, pattern: 'S #.##0,00');

double valorCarrinho = 0;

class CarrinhoWidget extends StatefulWidget {
  final List<Produto> produtos;
  const CarrinhoWidget({Key? key, required this.produtos}) : super(key: key);

  @override
  _CarrinhoWidgetState createState() => _CarrinhoWidgetState();
}

class _CarrinhoWidgetState extends State<CarrinhoWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    atualizaCarrinho();
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: widget.produtos.isNotEmpty
          ? FloatingActionButton.extended(
              elevation: 10,
              onPressed: () {
                //
                var itens = '';

                for (var element in widget.produtos) {
                  itens += 'Produto: ${element.nome}'
                      '\n'
                      'Quantidade: ${element.quantidadeCarrinho}un'
                      '\n'
                      '\n';
                }

                var uri =
                    'https://api.whatsapp.com/send/?phone=556692031150&text=$itens'
                    'Total: ${Money.fromNumWithCurrency(valorCarrinho, real)}';
                var encoded = Uri.encodeFull(uri);

                //print(itens);
                //log(itens);
                launch(encoded);

                //
              },
              icon: const FaIcon(FontAwesomeIcons.whatsapp),
              label: const Text('ENVIAR PELO WHATSAPP'),
            )
          : Container(),
      appBar: AppBar(
        //backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            //color: Color(0xFF95A1AC),
            size: 24,
          ),
          onPressed: () async {
            //Navigator.canPop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainAppPage())).then((value) {
              setState(() {});
            });
          },
        ),
        title: Text(
          'Carrinho',
          style: GoogleFonts.lexendDeca(
            //color: Color(0xFF151B1E),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 0,
      ),
      //backgroundColor: Color(0xFFF1F5F8),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3,
                    color: Color(0x4814181B),
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.lexendDeca(
                        //color: Color(0xFF8B97A2),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      '${Money.fromNumWithCurrency(valorCarrinho, real)}',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.lexendDeca(
                        //color: Color(0xFF151B1E),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  controller: ScrollController(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return itemCarrinho(index);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: widget.produtos.length),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemCarrinho(int index) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Ink(
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color.fromARGB(75, 139, 195, 74),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.lightGreen,
                        width: 0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ImageNetwork(
                                  image: widget.produtos[index].linkImagem,
                                  width: 74,
                                  height: 74,
                                  fitWeb: BoxFitWeb.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.produtos[index].nome,
                                  style: GoogleFonts.lexendDeca(
                                    //color: Color(0xFF111417),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 4),
                                  child: Text(
                                    'Color: Green',
                                    style: GoogleFonts.lexendDeca(
                                      //color: Color(0xFF090F13),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        splashRadius: 20,
                                        icon: const FaIcon(
                                          FontAwesomeIcons.minus,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          if (widget.produtos[index]
                                                  .quantidadeCarrinho >
                                              1) {
                                            widget.produtos[index]
                                                .quantidadeCarrinho--;
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'Excluir Item do Carrinho?'),
                                                content: Text(
                                                    'Deseja Excluir ${widget.produtos[index].nome} ?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Não'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      widget.produtos
                                                          .removeAt(index);
                                                      setState(() {
                                                        atualizaCarrinho();
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Sim'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          setState(() {
                                            atualizaCarrinho();
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 0, 4, 0),
                                        child: Container(
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xFFDBE2E7),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 4, 12, 0),
                                            child: Text(
                                              '${widget.produtos[index].quantidadeCarrinho}',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lexendDeca(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        splashRadius: 20,
                                        icon: const FaIcon(
                                          FontAwesomeIcons.plus,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          widget.produtos[index]
                                              .quantidadeCarrinho++;
                                          atualizaCarrinho();
                                          setState(() {});
                                        },
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 16, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${Money.fromNumWithCurrency(widget.produtos[index].valorVenda, real)}',
                                                style: GoogleFonts.lexendDeca(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 2,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget resumo() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.96,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x3A000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Resumo',
                    style: GoogleFonts.lexendDeca(
                      color: const Color(0xFF090F13),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: GoogleFonts.lexendDeca(
                      color: const Color(0xFF8B97A2),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    '[Price]',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.lexendDeca(
                      color: const Color(0xFF111417),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Entrega',
                    style: GoogleFonts.lexendDeca(
                      color: const Color(0xFF8B97A2),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    '[Price]',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.lexendDeca(
                      color: const Color(0xFF111417),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.lexendDeca(
                      color: const Color(0xFF8B97A2),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    '[Order Total]',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.lexendDeca(
                      color: const Color(0xFF151B1E),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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

  void atualizaCarrinho() {
    valorCarrinho = 0;
    for (var element in widget.produtos) {
      valorCarrinho += (element.valorVenda * element.quantidadeCarrinho);
    }
    carrinho = widget.produtos;
  }
}
