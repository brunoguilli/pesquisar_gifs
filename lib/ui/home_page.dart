import 'dart:convert';

import 'package:buscar_giffs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:buscar_giffs/ui/gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

// UI - USER INTERFACE

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _offset = 0;
  String _search;

  // Função que vai retornar um futuro
  Future<Map> _getGifs() async { 

    //Declarando a resposta
    http.Response response;

    // Desta forma, estamos fazendo um OU entre a pesquisa ser nula ou o texto estar vazio
    if(_search == null || _search.isEmpty)
      // Busca os melhores gifs automaticamente, caso o search estiver nulo
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=3EVU1Rc5EAk11RlKwuAXk1wDyPbW2gRF&limit=20&rating=G");
    else
      // Busca os gifs pelo parâmetros $_search e $_offset
      // &limit=19 : Foi definido 19 para sobrar um quadro para podermos acrescentar o botão para "Carregar mais gifs"
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=3EVU1Rc5EAk11RlKwuAXk1wDyPbW2gRF&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");

    return json.decode(response.body); 
  }

/*  @override
  void initState(){

    super.initState();
 
    _getGifs().then((map){

      print(map);
    
    });

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // O título será uma imagem na internet
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise Aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize:18.0 ),
              textAlign: TextAlign.center,
              // onSubmitted: Chama algo quando eu clico no OK no teclado do smartphone
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  // Precisa resetar o offset para mostrar os primeiros itens, caso clique em "carregar mais..."
                  _offset = 0;
                });
              },
            ),
          ),
          // Expanded: Os gifs vão utilizar todo o espaço da tela 
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context,snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        // Cor do indicator: Colocando uma animação totalmente parada do tipo cor
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if(snapshot.hasError) return Container();
                    else return _createGifTable(context,snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data){
    if(_search == null){
      // Mostra 19 quadros
      return data.length;
    } else {
      // Mostra todos os quadros (20)
      return data.length+1; 
    }
  }

  // Função que retorna um widget
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    // Retorna um widget em formato de grade
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      // Mostra como os itens serão organizados na tela
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // Quantos itens vai poder ter na horizontal
        crossAxisCount: 2,
        // Espaçamento dos itens na horizontal
        crossAxisSpacing: 10.0,
        // Espaçamento na vertical
        mainAxisSpacing: 10.0
      ), 
      // Quantidade de gifs que eu vou colcar na tela
      itemCount: _getCount(snapshot.data["data"]),
      // itemBuilder:
      //   Widget que eu vou colocar em cada posição
      //   Exemplo: Que item eu coloco no índice 0 ? Reposta: O widget que passarmos nessa posição
      itemBuilder: (context, index){
        // Precisa retornar o widget do index que definirmos
        
        // Se eu não estiver pesquisando, então eu vou mostrar a imagem 
        // index < snapshot.data["data"].length : se eu estiver pesquisando e não for o último item
        if(_search == null || index < snapshot.data["data"].length )
          // GestureDetector: Para que sejamos capaz de clicar nas imagens
          return GestureDetector(
            // FadeInImage: Efeito para as imagens não aparecerem abruptamente
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover
            ),
            // Ao clicar no gif
            onTap: (){
              // Navigator.push: Para ir para a próxima tela
              Navigator.push(context, 
                // Criando uma rota
                MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
              );
            },
            onLongPress:(){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0),
                  Text("Carregar mais...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0
                    ),
                  )
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19; 
                });
              },
            ),
          );
      },
    );
  }

}