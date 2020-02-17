// Página que mostrará o gif
import 'package:flutter/material.dart';
import 'package:share/share.dart';

// Não teremos nenhuma iteração na página, por isso ela será do tipo StatelessWidget
class GifPage extends StatelessWidget {

  // Dados recebidos pelo construtor 
  final Map _gifData;

  // Construtur
  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            // Comando de compartilhamento, vamos utilizar um pluggin chamado Share
            // Inserir no pubspec -> share: ^0.6.1+1
            onPressed: (){
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
          )
        ],
      ),
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"])
      ),
    );
  }
}