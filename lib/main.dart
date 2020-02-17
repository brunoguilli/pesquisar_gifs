/*
As versões recomendadas para este app são:

share: ^0.6.1+1
transparent_image: ^1.0.0
http: ^0.12.0+2
Guarde-as que logo você irá utilizá-las!

Um detalhe importante é que agora o http não vem mais importado por padrão no Flutter, 
então não se esqueça de adicioná-lo junto aos outros plugins!

Mas atenção: caso não utilize as versões sugeridas acima, há o risco do seu app não funcionar, 
e nesse caso não conseguiremos te ajudar. Por isso, utilize as versões sugeridas. 

Site que vai fornecer os gifs https://developers.giphy.com/

Request URL:

Trending
https://api.giphy.com/v1/gifs/trending?api_key=3EVU1Rc5EAk11RlKwuAXk1wDyPbW2gRF&limit=20&rating=G

Search
https://api.giphy.com/v1/gifs/search?api_key=3EVU1Rc5EAk11RlKwuAXk1wDyPbW2gRF&q=dogs&limit=25&offset=25&rating=G&lang=en

*/
import 'package:buscar_giffs/ui/gif_page.dart';
import 'ui/home_page.dart';
import 'package:flutter/material.dart'; // Elementos da interface de usuário


void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      highlightColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
      )
    ),
    
  ));
}

