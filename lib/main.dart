import 'package:boletaproto2new/services/GoogleLoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:boletaproto2new/Subasta/subastaEstate.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:workmanager/workmanager.dart';

import 'Horario/horario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    Workmanager().initialize(callbackDispatcher);

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APP ALUMNOS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleLoginScreen(),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    /******* BUTTON PARA LOGOUT *******/
    floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.arrow_right_alt_sharp),
        onPressed: () {
/************* MODAL O DIALOGO DE AVISO AL MOMENTO DE CERRAR SESION ***************/
          showDialog<String>(
            context: context,
            barrierColor: Colors.black45,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              content: const Text('¿Seguro que desea salir?',
                  style: TextStyle(color: Colors.black, fontSize: 20)),
              actions: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    child: const Text('No',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () => Navigator.pop(
                      context,
                      'No',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    child: const Text('Si',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      GoogleLogin().googleSignOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoogleLoginScreen()));
                    },
                  ),
                ),
              ],
            ),
          );
        }),
  );
}
