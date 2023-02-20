import 'package:flutter/material.dart';
import 'package:boletaproto2new/menuTarjetas/cards.dart';
import 'package:boletaproto2new/menuTarjetas/Class_CallCards.dart';
import 'package:boletaproto2new/Boletas/boletaState.dart';
import 'package:boletaproto2new/Subasta/subastaEstate.dart';
import 'package:boletaproto2new/Horario/horario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,

      //ENRUTAMOS
      routes: <String, WidgetBuilder>{
        "/horario": (BuildContext constext) => Horario(),
        "/boleta": (BuildContext constext) => boleta(title: "titulo"),
        "/subasta": (BuildContext constext) => const subasta(),
      },

      home: const MyHomePage(title: "Aplicacion Alumnos"),
    );
  }
}
