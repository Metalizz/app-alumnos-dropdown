import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:boletaproto2new/Subasta/materiasSubasta.dart';
import 'package:boletaproto2new/utils/endpoints.dart';
import 'package:boletaproto2new/menuTarjetas/var.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:marquee_widget/marquee_widget.dart';

class subasta extends StatefulWidget {
  const subasta({Key? key}) : super(key: key);

  @override
  State<subasta> createState() => _subastaState();
}

class _subastaState extends State<subasta> {
  List<materiasSubasta> listado = [];
  int materiasTotal = 0;
  int materiasActuales = 0;
  double ratio = 0.5;
  bool loading = true;

  List<materiasSubasta> _sortData(List<materiasSubasta> listado) {
    List<materiasSubasta> listaRoja = [], listaAmarilla = [];
    materiasTotal = listado.length;

    for (int i = 0; i < listado.length; i++) {
      materiasSubasta materia = listado[i];
      var evaluacion = materia.cupo / materia.lugar;
      if (evaluacion > 1.0) {
        listaRoja.add(materia);
        listado.remove(materia);
        i--;
      } else {
        if (evaluacion >= 0.7) {
          listaAmarilla.add(materia);
          listado.remove(materia);
          i--;
        }
      }
    }
    listaRoja.addAll(listaAmarilla);
    listaRoja.addAll(listado);
    for (materiasSubasta materia in listaRoja) {
      var valor = materia.cupo / materia.lugar;
      if (valor <= 1.0) {
        materiasActuales++;
      }
    }
    return listaRoja;
  }

  Future<List<materiasSubasta>> _getJsonData() async {
    List<materiasSubasta> listadoMateria = [];
    //String token = tknAlumno;
    String token = "a2b859a4-5f41-313a-b3e3-a58c8a6509d6"; //TOKEN SANDBOX
    //TODO REMOVER TOKEN SANDBOX
    //String urlCarga = SUBASTA + alumnoExpediente.toString();
    /* Expedientes de prueba:
      172456
      386199 //alumno especial
    */
    String urlCarga = SUBASTA + "172456";

    try {
      final response = await http.get(Uri.parse(urlCarga), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 30));
      //print("\nRespuesta:\n" + response.body + "\n");
      var rawData = jsonDecode(response.body);
      for (var element in rawData) {
        listadoMateria.add(materiasSubasta.fromJson(element));
      }

      var listado = _sortData(listadoMateria);
      return Future.value(listado);
    } catch (_e) {
      print("halgo salio mal");
      print(_e.toString());
      return Future.value([]);
    }
  }

  void _inicializar() async {
    int mt = 0, ma = 0;
    List<materiasSubasta> list = await _getJsonData().then((listado) {
      mt = listado.length;
      for (materiasSubasta materia in listado) {
        if (_revisarEstado(materia.lugar, materia.cupo) != 3) {
          ma++;
        }
      }
      return listado;
    });

    setState(() {
      listado = list;
      materiasTotal = mt;
      materiasActuales = ma;
      ratio = ma / mt;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 247, 247),
      appBar: AppBar(
        title: const Text("Subasta"),
      ),
      body: loading == true
          ? Center(
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(2)),
                const Text(
                  "Materias",
                  style: TextStyle(fontSize: 28),
                ),
                const Padding(padding: EdgeInsets.all(2)),
                Expanded(
                    flex: 1,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.height * 0.1,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                            value: ratio,
                            strokeWidth: 8,
                          ),
                        ),
                        Text(
                          "$materiasActuales/$materiasTotal",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                const Padding(padding: EdgeInsets.all(5)),
                Expanded(
                    flex: 8,
                    child: ListView(children: _listarTarjetas(listado))),
              ],
            ),
    );
  }

  Widget _crearExpansionTile(String titulo, List<materiasSubasta> lista) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        titulo,
        style: const TextStyle(fontSize: 20),
      ),
      trailing: _iconoParaExpansionTiles(_checarEstados(lista)),
      children: _listarTarjetas(lista),
    );
  }

  int _checarEstados(List<materiasSubasta> lista) {
    int result = 99;
    for (materiasSubasta materia in lista) {
      if (_revisarEstado(materia.lugar, materia.cupo) < result) {
        result = _revisarEstado(materia.lugar, materia.cupo);
      }
    }
    return result;
  }

  List<Widget> _listarTarjetas(List<materiasSubasta> lista) {
    List<Widget> listado = [];
    for (int i = 0; i < lista.length; i++) {
      listado.add(_crearTarjeta(lista[i]));
    }
    return listado;
  }

  int _revisarEstado(int lugar, int capacidad) {
    var resultado = lugar / capacidad;
    if (resultado >= 1) {
      //Fuera de la materia
      return 3;
    }
    if (resultado >= 0.7) {
      //casi fuera de la materia
      return 2;
    } else {
      //buena posicion en la materia
      return 1;
    }
  }

  Widget _crearTarjeta(materiasSubasta materia) {
    return Card(
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          side: BorderSide(
              width: 4.0,
              color: _evaluarColor(
                  (_revisarEstado(materia.lugar, materia.cupo) * 10)))),
      color: _evaluarColor(_revisarEstado(materia.lugar, materia.cupo)),
      elevation: 4,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      materia.descripcion,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip,
                    ))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    materia.tipoDescripcion,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    materia.actividad.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              RichText(
                  text: TextSpan(
                      text: "Lugar: ",
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                        text: "${materia.lugar}/${materia.cupo}",
                        style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))
                  ])),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_necesitaAsignatura(materia.subGrupo)],
        )
      ]),
    );
  }

  Icon _iconoParaExpansionTiles(int icono) {
    var iconSize = 35.0;
    switch (icono) {
      case 1:
        return Icon(
          Icons.expand_more,
          size: iconSize,
          color: Colors.black,
        );
      case 2:
        return Icon(
          Icons.warning,
          size: iconSize,
          color: Colors.amber,
        );
      case 3:
        return Icon(
          Icons.error,
          size: iconSize,
          color: Colors.red,
        );
      default:
        return Icon(
          Icons.exposure_minus_1,
          size: iconSize,
          color: Colors.black,
        );
    }
  }

  Widget _necesitaAsignatura(int necesitaMateria) {
    if (necesitaMateria != 0) {
      return Row(
        children: const [
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  side: BorderSide(
                      color: Color.fromARGB(255, 90, 47, 159), width: 2.5)),
              color: Color.fromARGB(255, 186, 186, 236),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  "REQUIERE OTRA ASIGNATURA",
                  style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 90, 47, 159),
                      fontWeight: FontWeight.bold),
                ),
              ))
        ],
      );
    } else {
      return Container(
        child: null,
      );
    }
  }

  Color _evaluarColor(int status) {
    switch (status) {
      case 1:
        return Colors.green.shade200;
      case 2:
        return Colors.amber.shade200;
      case 3:
        return Colors.red.shade200;
      //los valores de abajo se usan para el borde de la tarjeta
      case 10:
        return Colors.green.shade300;
      case 20:
        return Colors.amber.shade300;
      case 30:
        return Colors.red.shade300;
      default:
        return Colors.grey;
    }
  }
}
