import 'package:flutter/material.dart';
import 'package:pruebafluttergbp/pages/home_page.dart';
import 'package:pruebafluttergbp/pages/pelicula_page.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //DARK COLORS
        primaryColorDark: Color(0XFF2C3848),
        primaryColor: Colors.white,

        //LIGHT COLORS
        accentColor: Colors.black,
        primaryColorLight: Colors.white,
      ),
      title: 'Flutter Prueba',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => PeliculaDetalle(),
      },
    );
  }
}
