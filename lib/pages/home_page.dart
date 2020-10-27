import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pruebafluttergbp/bloc/pelicula_bloc.dart';
import 'package:pruebafluttergbp/widgets/swiper_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xff5CA0D3),
        body: _CreateHome(),
      ),
    );
  }
}

class _CreateHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      dragStartBehavior: DragStartBehavior.down,
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
              width: size.width,
              height: size.height * 0.2,
              child: _Encabezado()),
          _PeliculasContainer(size: size),
        ],
      ),
    );
  }
}

class _PeliculasContainer extends StatelessWidget {
  const _PeliculasContainer({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          PeliculasRecomendadas(),
          PeliculasTopRated(),

        ],
      ),
      
      height: size.height * 0.75,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25))),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Hello, what do you want to watch?',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        _BuscarInput()
      ],
    );
  }
}

class _BuscarInput extends StatelessWidget {
  const _BuscarInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hoverColor: Colors.white30,
          focusColor: Colors.white30,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 0, color: Colors.white30),
              borderRadius: BorderRadius.circular(50)),
          fillColor: Colors.white30,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.all(0),
          filled: true),
    );
  }
}

class PeliculasTopRated extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final peliculasBloc = new PeliculasBloc();

    peliculasBloc.getTopRated();

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('TOP RATED',
                  style: TextStyle(color: Colors.white),),),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasBloc.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasBloc.getTopRated,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

class PeliculasRecomendadas extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final peliculasBloc = new PeliculasBloc();

    peliculasBloc.getRecomendadas();

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('RECOMMENDED FOR YOU',
                  style: TextStyle(color: Colors.white),),),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasBloc.recomendadasStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasBloc.getRecomendadas,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

