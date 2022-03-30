import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget itemProduto(String nome, fornecedor, linkImagem, preco) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 53, 53, 53),
        borderRadius: BorderRadius.circular(15),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 5, 5, 0),
              child: AutoSizeText(
                nome,
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                maxLines: 2,
                minFontSize: 8,
              )),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 5, 0),
            child: Text(
              fornecedor,
              style: TextStyle(),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      linkImagem,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 1),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 5, 5),
            child: Text(
              preco,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ),
        ],
      ),
    ),
  );
}
