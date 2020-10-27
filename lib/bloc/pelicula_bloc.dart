import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:pruebafluttergbp/models/pelicula_model.dart';
import 'package:pruebafluttergbp/models/actor_model.dart';

class PeliculasBloc {
  String _apikey = 'df18dec5339b081ebc75b5577faa16b4';
  String _url = 'api.themoviedb.org';
  String _language = 'en-EN';

  int _popularesPage = 0;
  bool _cargando = false;

  int _recomendadasPage = 0;
  bool _cargandoRe = false;

  List<Pelicula> _populares = new List();
  List<Pelicula> _recomendadas = new List();

  final _popularesStreamController = StreamController<
      List<
          Pelicula>>.broadcast(); // para que muchas personas puedan escucharlo;

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  final _recomendadasStreamController = StreamController<
      List<
          Pelicula>>.broadcast(); // para que muchas personas puedan escucharlo;

  Function(List<Pelicula>) get recomendadasSink =>
      _recomendadasStreamController.sink.add;

  Stream<List<Pelicula>> get recomendadasStream =>
      _recomendadasStreamController.stream;

  void disposeStreams() {
    _recomendadasStreamController?.close();
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getTopRated() async {
    if (_cargando) return []; //si esta cargando no hace nada mas

    _cargando = true; //si cargando igual a false lo pone en true
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/top_rated', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false; //una vez que tiene la repsuesta pone cargando en false
    return resp;
  }

  Future<List<Pelicula>> getRecomendadas() async {
    if (_cargandoRe) return []; //si esta cargando no hace nada mas

    _cargandoRe = true; //si cargando igual a false lo pone en true
    _recomendadasPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _recomendadasPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _recomendadas.addAll(resp);
    recomendadasSink(_recomendadas);

    _cargandoRe = false; //una vez que tiene la repsuesta pone cargando en false
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }
}
