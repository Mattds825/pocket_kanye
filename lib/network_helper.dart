import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper{
  Future<KanyeQuote> fetchAlbum() async {
    final response = await http.get('https://api.kanye.rest/');
    if (response.statusCode == 200) {
      //respnse ok
      return KanyeQuote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load api');
    }
  }

}


class KanyeQuote{
  final String quote;

  KanyeQuote({this.quote});

  factory KanyeQuote.fromJson(Map<String, dynamic> json){
    return KanyeQuote(
      quote: json['quote'],
    );
  }
}