import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:boletaproto2new/Boletas/materias.dart';
import 'package:boletaproto2new/utils/endpoints.dart';
import 'package:boletaproto2new/menuTarjetas/var.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:calendar_view/calendar_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:boletaproto2new/menuTarjetas/cards.dart';
import '../utils/variablesGlobales.dart';
import 'dias.dart';
import 'materia.dart';
/*Notification */
import 'package:workmanager/workmanager.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:boletaproto2new/Notificaciones/services/notification_services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:boletaproto2new/Notificaciones/staticVars.dart';

class Horario extends StatefulWidget {
  @override
  _Horario createState() => _Horario();
}

/************ SHOW NOTIFICATION ************/
Future showNotification() async {
  int IndexNotification =
      Random().nextInt(StaticVars().listaEstatic.length - 1);

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '$IndexNotification.0',
    'HELLO',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    IndexNotification,
    'Pronto comenzara tu clase',
    StaticVars().listaEstatic[IndexNotification],
    platformChannelSpecifics,
  );
}

const simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";
@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  WidgetsFlutterBinding.ensureInitialized();

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  Workmanager().executeTask((task, inputData) async {
    showNotification();
    return Future.value(true);
  });
}

/**************************/
//Calcula el tiempo (Notificaciones)
int calculateRemainTimeInSeconds(String horaInicial) {
  DateTime _now = DateTime.now();
  int _nowInSeconds = _now.hour * 3600 + _now.minute * 60 + _now.second;
  //segundos sumados
  List<String> untilTime = horaInicial.split(":");

  int hour = int.parse(untilTime[0]);
  int minute = int.parse(untilTime[1]);

  print("**********************HORA/MINUTO*************************");
  print("THIS IS HOUR >> $hour");
  print("THIS IS MINUTES >> $minute");
  int _thenInSeconds = hour * 3600 + minute * 60;
  return _thenInSeconds - _nowInSeconds;
}

///FIN DEL METODO SOW NOTIFICATION

class _Horario extends State<Horario> {
  //JsonEvents events = JsonEvents();
  // List<CalendarEventData> eventData = [];
  // @override
  // void initState() {
  //   super.initState();
  //   //eventData = await JsonEvents.loadData();
  //   getEvents();
  // }

  // void getEvents() async{
  //   eventData = await JsonEvents.loadData();
  //   //eventData = await JsonEvents.mapEvents();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Horario"),
          backgroundColor: const Color.fromARGB(255, 0, 114, 63),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.calendar_view_week),
                tooltip: 'Ver Semana Completa.',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeekViewScreen()),
                  );
                }),
          ],
        ),
        body: DayViewScreen());
  }
}

//Widget containing both DayView (widget) and DayView's week header
class DayViewScreen extends StatefulWidget {
  // List<CalendarEventData> eventData;
  // DayViewScreen(this.eventData);

  @override
  _DayViewScreen createState() => _DayViewScreen();
}

class _DayViewScreen extends State<DayViewScreen> {
  final globalKey = GlobalKey<_WeekdayHeader>();

  List<CalendarEventData> eventData = [];
  @override
  void initState() {
    super.initState();
    //eventData = await JsonEvents.loadData();
    JsonEvents.initData();
    getEvents();
  }

  void getEvents() async {
    List<CalendarEventData> temp = await JsonEvents.loadData(context);
    setState(() {
      eventData = temp;
    });
    //eventData = await JsonEvents.mapEvents();
  }

  DateTime getCurrentDay() {
    DateTime currentDay;
    switch (DateTime.now().weekday) {
      //TODO: just add 21+weekday()...
      case 1: //monday
      case 7: //sunday
        currentDay = DateTime(2022, 8, 22, 0);
        break;
      case 2: //tuesday
        currentDay = DateTime(2022, 8, 23, 0);
        break;
      case 3: //wednesday
        currentDay = DateTime(2022, 8, 24, 0);
        break;
      case 4: //thursday
        currentDay = DateTime(2022, 8, 25, 0);
        break;
      case 5: //friday
        currentDay = DateTime(2022, 8, 26, 0);
        break;
      case 6: //saturday
        currentDay = DateTime(2022, 8, 27, 0);
        break;
      default:
        currentDay = DateTime.now();
    }
    final state = globalKey.currentState;
    state?.weekdayIndex = (currentDay.weekday < 7 ? currentDay.weekday : 1);
    state?.updateHeader();
    return currentDay;
  }

  @override
  Widget build(BuildContext context) {
    //post frame callback is called ONCE after it's done building
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });

    /******************* TAKE LOCAL HOUR NOTIFICATION **************************/
    DateTime dateNow = DateTime.now();
    String timer = "${dateNow.hour}:${dateNow.minute + 1}";
    print("timer >> $timer");
    int valor = calculateRemainTimeInSeconds(timer);
    print("valor >> $valor");

//Initialize Workmanager Default notification
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    return Stack(
      children: <Widget>[
        DayView(
          controller: EventController()..addAll(eventData),
          minDay: DateTime(2022, 8, 22, 6),
          maxDay: DateTime(2022, 8, 27, 23),
          heightPerMinute: 1.48,
          initialDay: getCurrentDay(),
          showLiveTimeLineInAllDays: true,
          onEventTap: (event, date) => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(event[0].title),
                    content: Text(event[0].description),
                    contentPadding:
                        const EdgeInsets.only(top: 40, bottom: 40, left: 30),
                    //backgroundColor: event[0].color,
                  )),
          onPageChange: (DateTime date, int index) {
            final state = globalKey.currentState;
            state?.weekdayIndex = index + 1;
            state?.updateHeader();
          },
        ),
        WeekdayHeader(key: globalKey),
        /****** NOTIFICATION BUTTONS *****/
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Workmanager().registerOneOffTask(
                    "1",
                    "notify_15_minutes_before_hour",
                    initialDelay: Duration(seconds: valor),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      // <-- Icon
                      Icons.notifications_active,
                      size: 30.0,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  await Workmanager().cancelAll();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        /*****************BUTTOMS NOTIFICATION FINISH********/
      ],
    );
  }
}

class WeekdayHeader extends StatefulWidget {
  const WeekdayHeader({Key? key}) : super(key: key);
  @override
  _WeekdayHeader createState() => _WeekdayHeader();
}

class _WeekdayHeader extends State {
  final weekdays = [
    "Cargando...",
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado"
  ];
  int weekdayIndex = 0;
  String displayText = "Lunes";

  updateHeader() {
    //this.weekdayIndex = weekdayIndex;
    setState(() {
      displayText = weekdays[weekdayIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          border: Border.all(color: Colors.blue.shade100, width: 1),
        ),
        child: Center(
          child: Text(
            weekdays[weekdayIndex],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ));
  }
}

// class DayViewWidget extends StatefulWidget {
//   const DayViewWidget({Key? key}) : super(key: key);
//   @override
//   _DayViewWidget createState() => _DayViewWidget();
// }

// class _DayViewWidget extends State {
//   @override
//   Widget build(BuildContext context) {
//     return DayView(
//       controller: EventController()..addAll(EventList.events),
//       minDay: new DateTime(2022, 8, 22, 6),
//       maxDay: new DateTime(2022, 8, 27, 23),
//       heightPerMinute: 1.48,
//       initialDay: DateTime(2022, 8, 22),
//       onEventTap: (event, date) => showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//                 title: Text(event[0].title),
//                 content: Text(event[0].description),
//               )),
//       onPageChange: (DateTime date, int index) {
//         //print("Current index = $index");
//       },
//     );
//   }
// }

class WeekViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /******************* TAKE LOCAL HOUR NOTIFICATION *****************************/

    DateTime dateNow = DateTime.now();
    String timer = "${dateNow.hour}:${dateNow.minute + 1}";
    print("timer >> $timer");
    int valor = calculateRemainTimeInSeconds(timer);
    print("valor >> $valor");

    //********Initialize Workmanager Default notification
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 114, 63),
          title: Text('Horario'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.calendar_view_day),
                tooltip: 'Ver Materias Diarias.',
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
        body: Stack(children: <Widget>[
          WeekView(
            controller: EventController()..addAll(JsonEvents.getEvents()),

            weekDays: [
              WeekDays.monday,
              WeekDays.tuesday,
              WeekDays.wednesday,
              WeekDays.thursday,
              WeekDays.friday,
              WeekDays.saturday
            ],
            minDay: DateTime(2022, 8, 22),
            maxDay: DateTime(2022, 8, 27),
            heightPerMinute: 1.5,
            onEventTap: (event, date) => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text(event[0].title),
                      content: Text(event[0].description),
                    )),
            //initialDay
          ),
          /****** NOTIFICATION BUTTONS *****/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Workmanager().registerOneOffTask(
                      "1",
                      "notify_15_minutes_before_hour",
                      initialDelay: Duration(seconds: valor),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        // <-- Icon
                        Icons.notifications_active,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    await Workmanager().cancelAll();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          /****** NOTIFICATION BUTTONS FINISH*****/
          Column(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    border: Border.all(color: Colors.blue.shade100, width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      "Vista Semanal",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 2, color: Colors.grey.shade200),
                  ),

                  //border: Border.all(color: Colors.blue.shade100, width: 1),
                ),
                child: Row(
                    //TODO: Add divisions here
                    //mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      WeekdayBox(" "),
                      WeekdayBox("Lu"),
                      WeekdayBox("Ma"),
                      WeekdayBox("Mi"),
                      WeekdayBox("Ju"),
                      WeekdayBox("Vi"),
                      WeekdayBox("Sa"),
                    ]),
              )
            ],
          ),
        ]));
  }
}

class WeekdayBox extends StatelessWidget {
  final String text;
  WeekdayBox(this.text);

  double calculateWidth() {
    return text == " " ? 20 : 30;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: calculateWidth(),
      decoration: BoxDecoration(
          //border: Border.all(color: Colors.red),
          ),
      child: Center(
          child: Text(text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ))),
    );
  }
}

class JsonEvents {
  static String? jsonRaw;
  static late Map<String, dynamic> jsonOutput;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static bool isValid = false;
  static String invalidMssg = "";
  static Set<materiaHorario> listaMaterias = Set();
  static List<CalendarEventData> _events = [];

  static void initData() {
    listaMaterias = Set();
    _events = [];
  }

  static Future<List<CalendarEventData>> loadData(context) async {
    GoogleSignInAccount? _user =
        await _googleSignIn.signInSilently(suppressErrors: true);
    //String urlCarga = HORARIO + alumnoExpediente.toString();
    /* Expedientes de prueba:
      397670
      342513
      273135
      301136
    */
    String urlCarga = HORARIO + expedienteP.toString() + "&secret=" + secret;

    //HORARIO + "397670" + "&secret"+secret;
    //TODO remover el expediente dummy
    print(urlCarga);
    try {
      final response = await http.get(Uri.parse(urlCarga), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await BlackBox.getServiceToken()}',
      }).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final _loadedData = response.body;

        if (_loadedData.contains('"materias":[{')) {
          isValid = true;
        } else {
          isValid = false;
          invalidMssg = "No se encontró carga academica";
        }

        if (_user == null) {
          isValid = false;
          invalidMssg = "No hay usuario activo";
        }

        //setState(() {
        if (isValid) {
          jsonRaw = _loadedData;
          jsonOutput = jsonDecode(jsonRaw!);
          // List<dynamic> tempList = jsonOutput['unidad'];
          // Set<dynamic> jsonMap = tempList.toSet();
          List<dynamic> jsonMap = jsonOutput['materias'];
          for (var element in jsonMap) {
            materiaHorario materia = materiaHorario.fromJson(element);
            listaMaterias.add(materia);
          }
        }
        //});
      } else if (response.statusCode == 400) {
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
      } else if (response.statusCode == 404) {
        AlertDialog alert = AlertDialog(
          title: Text('Alerta'),
          content: Text("Error de aplicacion (Codigo 102"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: ElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
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
      } else if (response.statusCode == 500) {
        AlertDialog alert = AlertDialog(
          title: Text('Alerta'),
          content: Text("Error de aplicación (Codigo 202"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: ElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
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
      } else if (response.statusCode == 504) {
        AlertDialog alert = AlertDialog(
          title: Text('Alerta'),
          content: Text("Error de aplicación (Codigo 203"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: ElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
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
      } else if (response.statusCode == 555) {
        AlertDialog alert = AlertDialog(
          title: Text('Alerta'),
          content: Text("Error de aplicaion Codigo(204)"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: ElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
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
      } else {
        AlertDialog alert = AlertDialog(
          title: Text('Alerta'),
          content: Text("Error de aplicación (Código 999)"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: ElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
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

      return await mapEvents();
    } on SocketException catch (_) {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: 'Menu',
                              )),
                    );
                    //Navigator.of(context).pop();
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
      throw " ";
    }
  }

  static Future<List<CalendarEventData>> mapEvents() async {
    if (!isValid) {
      print("Invalid user");
      return Future.value(_events);
    }

    List<DateTime> weekdays = [
      DateTime(2022, 8, 22),
      DateTime(2022, 8, 23),
      DateTime(2022, 8, 24),
      DateTime(2022, 8, 25),
      DateTime(2022, 8, 26),
      DateTime(2022, 8, 27)
    ];

    //navega por cada facultad
    for (materiaHorario materia in listaMaterias) {
      //navega por la lista de asignaturas
      for (dias diaMateria in materia.listDias) {
        print(
            "HORAAAAAAAAAAAAAAAAAAAAAAAA ${materia.desc_activ} ${diaMateria.hora_inicial} - ${diaMateria.hora_final}");
        //int i = 0;
        //crea eventos en base al dia
        //while (i < diaMateria.dias.length) {
        //if (diaMateria.dias[i] == "1") {
        //Create event color
        String eventColorName = materia.actividad.toString();
        while (eventColorName.length < 7) {
          eventColorName = "${eventColorName}0";
        }
        eventColorName = "0xFF${eventColorName}";
        Color eventColor = Color(int.parse(eventColorName));

        //Create event
        CalendarEventData eventData = CalendarEventData(
            title: materia.desc_activ.trim(),
            date: weekdays[diaMateria.num_dia - 1],
            description:
                "Salón: ${materia.desc_espacio}\nGrupo: ${materia.grupo}\nTipo: ${materia.descripcion}\nHorario: ${diaMateria.hora_inicial} - ${diaMateria.hora_final}",
            startTime: DateTime(
                weekdays[diaMateria.num_dia - 1].year,
                weekdays[diaMateria.num_dia - 1].month,
                weekdays[diaMateria.num_dia - 1].day,
                int.parse(diaMateria.hora_inicial.split(':')[0]), //horaInicio
                int.parse(diaMateria.hora_inicial.split(':')[1]) //minutosInicio
                ),
            endTime: DateTime(
                weekdays[diaMateria.num_dia - 1].year,
                weekdays[diaMateria.num_dia - 1].month,
                weekdays[diaMateria.num_dia - 1].day,
                int.parse(diaMateria.hora_final.split(':')[0]), //horaInicio
                int.parse(diaMateria.hora_final.split(':')[1]) //minutosInicio
                ),
            color: eventColor);
        _events.add(eventData);
      }
    }
    //opCode = "${listaUnidades.length}" as Future<String>;
    return Future.value(_events);
  } //add breakpoint here

  static List<CalendarEventData> getEvents() {
    return _events;
  }
}
