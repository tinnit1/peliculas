import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasService {
  String _apikey = 'bb0785cbe839bfab0517d27282d39b17';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _loading = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void diposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarResponse(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodeData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});
    return await _procesarResponse(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_loading) return [];
    _loading = true;
    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarResponse(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _loading = false;
    return resp;
  }

  Future<List<Actor>> getActors( String moviId) async{
    final url = Uri.https(_url, '3/movie/$moviId/credits', 
      {'api_key': _apikey, 'language': _language}
    );
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final Actores actores = new Actores.fromJsonList(decodeData['cast']);
    return actores.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});
    return await _procesarResponse(url);
  }
}
