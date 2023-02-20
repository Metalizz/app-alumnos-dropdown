import 'package:flutter/material.dart';
import 'package:boletaproto2new/services/GoogleLoginScreen.dart';
import 'package:boletaproto2new/menuTarjetas/var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("CONTRASEÑA"),
        backgroundColor: Colors.cyan, //Color a la barra del encabezado
      ),
      backgroundColor: Colors.cyan[100], //Color de fondo de pantalla
      body: (Text('BIENVENIDO A LA PANTALLA DE CONTRASEÑA',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0))),
    );
  }
}

class Boleta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("boleta"),
        backgroundColor: Colors.pink, //Color a la barra del encabezado
      ),
      backgroundColor: Colors.pink[100], //Color de fondo de pantalla

      body: (Text('BIENVENIDO A LA PANTALLA DE BOLETA',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0))),
    );
  }
}

class Subasta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subasta"),
        backgroundColor: Colors.red, //Color a la barra del encabezado
      ),
      backgroundColor: Colors.red[100], //Color de fondo de pantalla

      body: (Text('BIENVENIDO A LA PANTALLA DE LA SUBASTA',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0))),
    );
  }
}
