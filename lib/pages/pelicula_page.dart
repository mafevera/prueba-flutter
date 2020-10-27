import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:pruebafluttergbp/bloc/pelicula_bloc.dart';
import 'package:pruebafluttergbp/models/actor_model.dart';
import 'package:pruebafluttergbp/models/pelicula_model.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula =
        ModalRoute.of(context).settings.arguments; //obtener la pelicula
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        body: CustomScrollView(
          slivers: <Widget>[
            _crearAppbar(pelicula, size, context),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 10.0),
                _posterTitulo(context, pelicula),
                SizedBox(
                  height: 10.0,
                ),
                _crearCasting(pelicula),
                SizedBox(
                  height: 10.0,
                ),
                _datos('Release', pelicula.releaseDate),
                _datos('Genre', pelicula.genreIds.toString()),
              ]),
            )
          ],
        ));
  }

  Widget _crearAppbar(Pelicula pelicula, Size size, BuildContext context) {
    return SliverAppBar(
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      //se puede ocultar cuando hago scroll
      elevation: 2.0,
      backgroundColor: Color(0xff5CA0D3),
      expandedHeight: size.height * 0.4,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 50, bottom: 15),
        centerTitle: true,
        title: Text(
          pelicula.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 15),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        pelicula.title,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.hd,
                      color: Colors.white,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'WATCH NOW',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RatingBar(
                      itemSize: 20,
                      initialRating: pelicula.voteAverage,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.only(right: 4),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (value) {},
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Text(
        pelicula.overview,
        style: TextStyle(
          color: Colors.white70,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliBloc = new PeliculasBloc();

    return FutureBuilder(
      future: peliBloc.getCast(pelicula.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 120.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i]),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
        child: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(200.0),
          child: FadeInImage(
            image: NetworkImage(actor.getFoto()),
            placeholder: AssetImage('assets/img/no-image.jpg'),
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          actor.name,
          style: TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        )
      ],
    ));
  }
}

Widget _datos(String tipo, String dato) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$tipo: ',
          style: TextStyle(
              color: Colors.white, height: 2, fontWeight: FontWeight.bold),
        ),
        Text(
          '$dato',
          style: TextStyle(color: Colors.white70, height: 2),
        ),
      ],
    ),
  );
}
