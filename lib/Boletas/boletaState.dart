import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:boletaproto2new/menuTarjetas/var.dart';
import 'package:flutter/material.dart';
import '../utils/endpoints.dart';
import '../utils/variablesGlobales.dart';
import 'alumnos.dart'; //clase modelo de alumnos
import 'package:boletaproto2new/services/GoogleLoginScreen.dart';
import 'package:boletaproto2new/menuTarjetas/var.dart';
import 'package:http/http.dart' as http;

class boleta extends StatefulWidget {
  boleta({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<boleta> createState() => _boletaState();
}

class _boletaState extends State<boleta> {
  List<Datos> data = <Datos>[];
  int? tappedIndex;

  bool loading = true;

  tomar_datos() async {
    String urlCarga = MATERIAS + expedienteP.toString() + "&secret=" + secret;
    print(urlCarga);

    try {
      var response = await http.get(Uri.parse(urlCarga), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await BlackBox.getServiceToken()}',
      });

      var registros = <Datos>[];

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        print(jsonData);
        print("ESTAS SON LAS MATERIAS: ${jsonData['materias']}");
        if (jsonData["materias"] != null) {
          for (var item in jsonData["materias"]) {
            registros.add(Datos.fromJson(item));
          }
        } else {
          print("No tiene Materias");
          AlertDialog alert = AlertDialog(
            title: Text('Alerta'),
            content: Text("NO TIENE GRUPOS"),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: ElevatedButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 11, 155, 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
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
      if (response.statusCode == 400) {
        /* var snackBar = SnackBar(content: Text('Error de aplicación (Código 400)'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
        AlertDialog alert = AlertDialog(
          title: Text('Alerta'),
          content: Text("Error de aplicación (Código 101)"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 11, 155, 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

      return registros;
    } on TimeoutException catch (_) {
      print("A timeout occurred.");
      throw "Timeout";
    } on SocketException catch (_) {
      print("Other exception");
      AlertDialog alert = AlertDialog(
        title: Text('Alerta'),
        content: Text(
            "Error de conexion, favor de revisar la conexión a internet (Código 103)"),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 11, 155, 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      throw "Timeout";
    }
  }

  @override
  void initState() {
    super.initState();
    tappedIndex = 0;

    tomar_datos().then((value) {
      setState(() {
        data.addAll(value);
        loading = false;
      });
    });
  }

  MaterialColor pintar(String calificacion) {
    /*Este metodo regresa el color necesario para pintar
    las tarjetas de acuerdo a la calificacion en cada materia*/
    try {
      //si la calificacion es numerica entonces
      //estas lineas de codigo se ejecuta
      int califNum = int.parse(calificacion);
      if (califNum > 79) {
        return Colors.green;
      } else {
        if (califNum > 61) {
          return Colors.yellow;
        } else {
          return Colors.red;
        }
      }
    } catch (e) {
      //si la calificacion no es numerica entonces
      //estas lineas de codigo se ejecutan
      switch (calificacion) {
        case "A":
          return Colors.green;
        case "NA":
          return Colors.red;
        case "NC":
          return Colors.grey;
        case "NP":
          return Colors.red;
        case "SD":
          return Colors.red;
        default:
          return Colors.grey;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Boleta"),
          backgroundColor: Color.fromARGB(255, 0, 114, 63),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: loading == true
                  ? Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  :
                  //Lista de calificaciones
                  Expanded(
                      flex: 12,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 10,
                            color: pintar(data[index].calificacion),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              //contenido de las tarjetas se define aqui
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.all(5),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          //nombre de la materia
                                          child: Text(
                                        data[index].descripcion,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Column(
                                        //esta columna permite que la calificacion y
                                        //tipo de examen se despliegue uno encima de otro
                                        children: [
                                          Text(
                                            //Calificacion
                                            data[index].calificacion,
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            //tipo de examen
                                            data[index].tipoexadesc,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  subtitle: Container(
                                    //este contenedor incluye la tarjeta blanca con la
                                    //informacion adicional de la materia
                                    child: ListTile(
                                      tileColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            //Nombre del profesor y descripcion de
                                            //las siglas si es que aplica
                                            data[index].nomtitular +
                                                "\n" +
                                                data[index].glosario(),

                                            style:
                                                const TextStyle(fontSize: 22),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        // la verdad no entiendo del todo que hace esto de aqui
                        //visual lo genero automaticamente
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      )),
            )
          ],
        ));
  }
}

class Datos {
  var actividad;
  String descripcion = "";
  String tipoexadesc = "";
  String nomtitular = "";
  var calificacion;

  Datos(this.actividad, this.descripcion, this.tipoexadesc, this.nomtitular,
      this.calificacion);

  Datos.fromJson(Map<String, dynamic> json) {
    actividad = json['actividad'];
    descripcion = json['descripcion'];
    tipoexadesc = json['tipoexadesc'];
    actividad = json['actividad'];
    nomtitular = reformatearNombre(json['nomtitular']);

    //nomtitular=json['nomtitular'];
    calificacion = json['calificacion'];
  }

  String glosario() {
    //Este metodo regresa un String con la descripcion apropiadad de la
    //calificaion que obtuvo el estudiante asumiendo que la calificacion
    //no es numerica por alguna de las siguientes razones
    try {
      //si este try no falla regresa un String vacio
      int.parse(calificacion);
      return "";
    } catch (e) {
      //si la calificacion no es numerica se ejecuta las siguientes lineas y
      //regresa la linea adecuada para mostrar en la tarjeta
      switch (calificacion) {
        case 'A':
          return "A: Aprobado";
        case 'NA':
          return "NA: No Aprobado";
        case 'NC':
          return "NC: No Capturado";
        case 'SD':
          return "SD: Sin Derecho";
        case 'NP':
          return "NP: No Presento";
        default: //Este default probablemente esta sobrando pero lo inclui de todas formas
          return "";
      }
    }
  }

  static String reformatearNombre(String nombre) {
    //Este metodo reformatea el nombre del profesor de la materia para que se
    //pueda ver mas presentable en la tarjeta

    //revisa caracter por caracter si el caracter actual es o no es un espacio,
    //si es un espacio lo agrega y cambia la bandera a true para que el programa
    //sepa que ya hay un espacio y no agregue extras, solo cuando se encuentra un
    //caracter differente a un espacio la bandera regresa a falso y se podra agregar
    //un espacio otra vez
    String nombFormat = "";
    bool alreadySpaced = false;
    for (int i = 0; i < nombre.length; i++) {
      if (nombre[i] == " ") {
        if (!alreadySpaced) {
          nombFormat = nombFormat + " ";
          alreadySpaced = true;
        }
      } else {
        nombFormat = nombFormat + nombre[i];
        alreadySpaced = false;
      }
    }
    return nombFormat;
  }
}
