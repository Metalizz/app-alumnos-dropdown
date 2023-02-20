import 'package:flutter/material.dart';
import 'package:boletaproto2new/services/GoogleLoginScreen.dart';
import 'package:boletaproto2new/menuTarjetas/var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Perfil Alumno"),

        backgroundColor:
            Color.fromARGB(179, 75, 132, 25), //Color a la barra del encabezado
      ),
      backgroundColor: Color.fromARGB(255, 254, 255, 253),
      //Color de fondo de pantalla

      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
              color: Color.fromARGB(255, 2, 71, 49),
              image: DecorationImage(
                image: AssetImage("assets/images/fondoVerde.png"),
                fit: BoxFit.contain,
              ),
            )),
          ),
          LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                //padding: EdgeInsets.only(top:15),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                  image: AssetImage("assets/images/escudo.png"),
                                  height:
                                      (MediaQuery.of(context).size.height) / 8,
                                ),
                                Container(
                                    width: viewportConstraints.maxWidth / 1.6,
                                    child: Text(
                                        'Universidad Autónoma de Baja California',
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontSize: 20 +
                                              (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015),
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center)),
                              ],
                            ),
                          ),
                          Container(
                            width: 145 +
                                (MediaQuery.of(context).size.height * 0.015),
                            height: 145 +
                                (MediaQuery.of(context).size.height * 0.015),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 5,
                                color: Colors.black,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    '${auth.currentUser?.photoURL}'),
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text('${auth.currentUser?.displayName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17 +
                                    (MediaQuery.of(context).size.height *
                                        0.015),
                              ),
                              textAlign: TextAlign.center),
                          Text('Matrícula: ${matriculaAlumno}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15 +
                                      (MediaQuery.of(context).size.height *
                                          0.01)),
                              textAlign: TextAlign.center),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text('${carreraAlumno}',
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20 +
                                        (MediaQuery.of(context).size.height *
                                            0.015),
                                    color:  Color(0xffFEBE10),
                                  ),
                                  textAlign: TextAlign.center)),
                        ]
                    )
                  ),
              );
            },
          )
        ]),
      ),
    );
  }
}
