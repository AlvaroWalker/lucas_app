import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:lucas_app/api/firebase_api.dart';
import 'package:lucas_app/classes/produtos.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({
    Key? key,
  }) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  String imageUrl = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController fornecedorController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController valorVendaController = TextEditingController();
  TextEditingController estoqueController = TextEditingController();

  UploadTask? task;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  CollectionReference produtos =
      FirebaseFirestore.instance.collection('produtos');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String nomeArquivoFoto = '';
  String itemId = '';

  XFile? imagebatata;

  Future selecionaImagem() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 65);

    imagebatata = image;
  }

  Future uploadImagem() async {}

  Future<void> uploadFile(String filePath) async {
    XFile file = XFile(imagebatata!.path);

    dynamic aros = await file.readAsBytes();

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('$nomeArquivoFoto.jpg')
          .putData(aros);
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Novo Produto'),
        actions: [
          IconButton(
              onPressed: () {
                salvarProduto(Produto(
                        nome: nameController.text,
                        estoque: int.parse(estoqueController.text),
                        valorVenda: double.parse(valorVendaController.text),
                        fornecedor: fornecedorController.text,
                        tipo: tipoController.text,
                        nicotina: false,
                        mgNicotina: 1,
                        valorEstoque: 1,
                        linkImagem: nomeArquivoFoto))
                    .then((value) {
                  Navigator.pop(context);
                });
              },
              icon: const FaIcon(FontAwesomeIcons.save))
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        nomeArquivoFoto,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  selecionaImagem();
                },
                child: const Text('Adicionar Foto')),
            task != null
                ? buildUploadStatus(task!)
                : ElevatedButton(
                    onPressed: () async {
                      uploadExample();
                    },
                    child: const Text('Upar Foto')),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Produto',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
              child: TextFormField(
                controller: fornecedorController,
                decoration: const InputDecoration(
                  labelText: 'Fornecedor',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
              child: TextFormField(
                controller: tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
              child: TextFormField(
                controller: valorVendaController,
                decoration: const InputDecoration(
                  labelText: 'Valor de Venda',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
              child: TextFormField(
                controller: estoqueController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade em Estoque',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadExample() async {
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = imagebatata!.path;
    XFile xFile = XFile(imagebatata!.path);

    dynamic uint8data = await xFile.readAsBytes();

    task = FirebaseApi.uploadBytes('$itemId.jpg', uint8data);
    setState(() {});
    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    setState(() {
      nomeArquivoFoto = url;
    });
  }

  Future<void> salvarProduto(Produto _prod) {
    return produtos
        .add({
          'nome': _prod.nome,
          'fornecedor': _prod.fornecedor,
          'linkImagem': _prod.linkImagem,
          'mgNicotina': _prod.mgNicotina,
          'nicotina': _prod.nicotina,
          'estoque': _prod.estoque,
          'valorVenda': _prod.valorVenda,
          'valorEstoque': _prod.valorEstoque,
          'tipo': _prod.tipo,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(0);

            return Text(
              '$percentage %',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
