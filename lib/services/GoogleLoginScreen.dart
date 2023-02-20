import 'dart:convert';
import 'dart:developer';
import 'package:boletaproto2new/menuTarjetas/var.dart';
import 'package:boletaproto2new/menuTarjetas/maintarjetas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boletaproto2new/utils/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:boletaproto2new/Boletas/alumnos.dart';

import '../utils/variablesGlobales.dart';

class GoogleLoginScreen extends StatefulWidget {
  @override
  GoogleLogin createState() => GoogleLogin();
}

class GoogleLogin extends State<GoogleLoginScreen> {
  final _googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  String accessTokenGoogle = "";
  String datosTokenServerAlumnos = "";
  String _CuentaEmail = "";

//Metodo de autenticacion de google y firebase
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      accessTokenGoogle = "${googleSignInAuthentication.accessToken}";
      print("Este es el token de google: ${accessTokenGoogle}");

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        assert(userCredential.user?.uid == auth.currentUser?.uid);
        user = userCredential.user;

        await onSignIn();

        _isCurrentSignIn(user!);
      } on FirebaseAuthException catch (e) {
        if (e.code == "cuenta-existe-con-diferente-credencial") {
          log("cuenta-existe-con-diferente-credencial");
        } else if (e.code == "credencial-invalida") {
          log("credencial-invalida");
        }
      } catch (e) {
        log("otro error: ${e}");
      }
    }
    return user;
  }

//Muestra los datos del usuario
  Future<User?> _isCurrentSignIn(User user) async {
    if (user != null) {
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = auth.currentUser;
      assert(user.uid == currentUser?.uid);

      return user;
    }
    return null;
  }

  //Metodo para cerrar  la sesion
  googleSignOut() async {
    await auth.signOut();
    await _googleSignIn.signOut();
  }

////////////////////////////////////////////////////////////////////////////////
//Funcion para usar el servicio de alumnos
  Future<String> postToken(String googleToken, String SERVERALUMNOURL) async {
    final response = await http.post(
      Uri.parse(SERVERALUMNOURL),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'accessToken': googleToken,
      }),
    );
    try {
      Datos datosTokenServerAlumnos = Datos.fromJson(jsonDecode(response.body));
      await BlackBox.setToken(datosTokenServerAlumnos.accesstoken);
      _CuentaEmail = datosTokenServerAlumnos.email;
      secret = datosTokenServerAlumnos.secret;
      //TokenServicesAlumnos = datosTokenServerAlumnos.accesstoken;
    } catch (e) {}
    print(response.body);
    return '${response.body}';
  }

  Future<String> fetchPost(urlEmailAlumno) async {
    //var tokenAlumno = TokenServicesAlumnos;
    //var url = urlEmailAlumno + "&secreRt=" + secret.toString();
    //var correoS = "ariel.cardenas@uabc.edu.mx";
    //var urlEmailAlumno = CorreoUABCEstudiante + correoS;
    var url = CorreoUABCEstudiante + _CuentaEmail;
    //user!.email!;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await BlackBox.getServiceToken()}',
    });

    final responseJson = await json.decode(response.body);
    //print("informacion del response data");
    print("\n\n" + response.body + "\n\n");
    PEducativos = responseJson['programasEducativos'];
    estado = responseJson['programasEducativos'][0]['programaEducativo'];

    matriculaAlumno = responseJson["matricula"];
    print(matriculaAlumno);

    carreraAlumno = responseJson["programasEducativos"][0]["programaEducativo"];
    print(carreraAlumno);

    estadoAlumno = responseJson["programasEducativos"][0]["estado"];
    print(estadoAlumno);
    print(responseJson["programasEducativos"][0]["expediente"]);

    //alumno 1 2 materias: 319081
    //alumno 2 6 materias: 319637
    //viejo alumno 319637
    /* var materiaTest = await http.get(
        Uri.parse(MATERIAS + "343114" + "&secret=" + secret.toString()),
        /*var materiaTest = await http.get(
        Uri.parse(MATERIAS +
            responseJson["programasEducativos"][0]["expediente"].toString()),*/
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await BlackBox.getServiceToken()}',
        });

    print("\nAlumnos:");
    print(materiaTest.body);

    if (materiaTest.body != "{}") {
      isAlumnoExpedienteEmpty = false;
      print("\naluno no vacio");
      alumnoExpediente = alumnos.fromJson(jsonDecode(materiaTest.body));
    } else {
      isAlumnoExpedienteEmpty = true;
      print("\nalumno vacio");
    }*/
    return '${responseJson}';
  }

//Metodo Guardar el token de google y utilizar servicios
  onSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var correoAlumno = user!.email;
    var regExpAlumno = RegExp(r'(humming)?@uabc.edu.mx');

    if (regExpAlumno.hasMatch(correoAlumno!)) {
      var googletoken = accessTokenGoogle;

      //Aqui guardamos el token de Google para su uso.
      await prefs.setString("googleToken", googletoken);

      await postToken(accessTokenGoogle, SERVER_ALUMNO_URL);

      //var tokenAlumno = TokenServicesAlumnos;
      //tknAlumno = TokenServicesAlumnos;

      var urlEmailAlumno = CorreoUABCEstudiante + user!.email!;

      await fetchPost(urlEmailAlumno);
      print("CORREO INGRESADO >> " + urlEmailAlumno);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          auth.signOut();
          _googleSignIn.signOut();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("Alerta"),
        content: Text("No es correo institucional"),
        actions: [
          okButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

////////////////Vista de Login
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return SafeArea(
        child: Scaffold(
            body: Center(
                child: Stack(children: <Widget>[
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) / 3,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 114, 63),
                // image: DecorationImage(
                //   image: AssetImage('assets/images/escudo.png'),
                //   scale: 15,
                //   fit: BoxFit.none,
                // )
              ),
              child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image(
                        image: AssetImage('assets/images/escudo.png'),
                        height: (MediaQuery.of(context).size.height) / 5),
                    Center(
                        child: Text(
                      "Aplicación de Alumnos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            20 + (MediaQuery.of(context).size.height * 0.01),
                      ),
                    )),
                  ]),
            ),
            Container(
                //padding: EdgeInsets.only(bottom: 200),
                child: IconButton(
              icon: Image.asset('assets/images/googleLogin.png'),
              iconSize: 220 + (MediaQuery.of(context).size.height * 0.01),
              onPressed: () async {
                await signInWithGoogle();
                //TODO: Descomentar la linea de arriba
                /*Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Nav()));*/
              },
            )),
            Container(
                // padding: ,
                ),
          ]),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
                'Universidad Autónoma de Baja California,\nDerechos Reservados México ${now.year}',
                textAlign: TextAlign.center)),
      )
    ]))));
  }
}

//Clase para poder utilizar los datos del servicio (access_token)
class Datos {
  final String accesstoken, secret, email;
  const Datos(
      {required this.accesstoken, required this.secret, required this.email});

  factory Datos.fromJson(Map<String, dynamic> json) {
    return Datos(
        accesstoken: json['access_token'],
        secret: json['secret'],
        email: json['email']);
  }
}
