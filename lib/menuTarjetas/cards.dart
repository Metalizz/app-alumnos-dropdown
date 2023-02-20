import 'package:flutter/material.dart';
import 'package:boletaproto2new/menuTarjetas/Class_CallCards.dart';
import 'package:boletaproto2new/services/GoogleLoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:boletaproto2new/menuTarjetas/perfil.dart';
import 'package:boletaproto2new/menuTarjetas/var.dart';

import '../utils/variablesGlobales.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic dropdownvalue;

  double cardH = 0;
  double cardW = 0;
  double ratio = 0;
  @override
  void initState() {
    super.initState();
    expedienteP = PEducativos[0]['expediente'];
    print(expedienteP);
  }

  @override
  Widget build(BuildContext context) {
    ratio = _setSize(context);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green, //color de fondo barra de menu
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),

          //backgroundColor: Colors.green[200],//Fondo de pantalla
          drawer: Menulateral(),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 250, 246, 246),
              image: const DecorationImage(
                  image: const AssetImage("assets/images/fondouabc.png"),
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight),
            ),
            padding: const EdgeInsets.all(30.0),
            child: AspectRatio(
                aspectRatio: ratio,
                child: SafeArea(
                    //padding: EdgeInsets.only(left:10, right: 10),
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButton(
                          // icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 7, 7, 7)),
                          underline: Container(
                            height: 2,
                            color: Color.fromARGB(255, 1, 116, 16),
                          ),
                          hint: Text(
                            estado,
                            style: TextStyle(color: Colors.black),
                          ),
                          items: PEducativos.map((item) {
                            print(item);
                            return DropdownMenuItem(
                              value: item,
                              child: Text("${item['programaEducativo']} "),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue = newVal;
                              expedienteP = dropdownvalue['expediente'];
                              carreraAlumno =
                                  dropdownvalue['programaEducativo'];
                            });
                          },
                          value: dropdownvalue,
                        ),
                      ],
                    ),

                    //Primer renglon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _tarjeta("Horario", Icons.calendar_month, 4,
                            _goToHorario(context)),
                        _tarjeta("Boleta", Icons.ballot_outlined, 4,
                            _goToBoleta(context))
                      ],
                    ),
                    //Segundo renglon
                    /*   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _tarjeta("Subasta", Icons.gavel_rounded, 4,
                            _goToSubasta(context)),
                        //Sized Box se encarga de mantener el espacio vacio en la cuadricula
                        SizedBox(
                          width: cardW,
                          height: cardH,
                          child: null,
                        )
                      ],
                    )*/
                  ],
                ))),
          )),
    );
  }

  double _setSize(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double AR;
    if (screenWidth < screenHeight) {
      AR = (screenWidth + 50) / screenHeight;
      cardH = MediaQuery.of(context).size.width * 0.4;
      cardW = MediaQuery.of(context).size.width * 0.4;
    } else {
      AR = (screenWidth + 50) / screenHeight;
      cardH = MediaQuery.of(context).size.height * 0.25;
      cardW = MediaQuery.of(context).size.height * 0.7;
    }
    return AR;
  }

  Widget _tarjeta(
      String nombre, IconData icono, double fontSize, void Function() funcion) {
    return SizedBox(
      width: cardW,
      height: cardH,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(
              color: Color.fromARGB(179, 75, 132, 25), width: 1),
        ),
        margin: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: funcion,
          splashColor: Colors.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(
                        icono,
                        color: const Color.fromARGB(255, 32, 60, 50),
                      )),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      child: Text(
                        nombre,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void Function() _goToBoleta(BuildContext context) {
    return () {
      Navigator.pushNamed(context, "/boleta");
    };
  }

  void Function() _goToHorario(BuildContext context) {
    return () {
      Navigator.pushNamed(context, "/horario");
    };
  }

  void Function() _goToSubasta(BuildContext context) {
    return () {
      Navigator.pushNamed(context, "/subasta");
    };
  }
}

/******************************** MENU LATERAL *******************************/
class Menulateral extends StatefulWidget {
  @override
  _MenulateralState createState() => _MenulateralState();
}

class _MenulateralState extends State<Menulateral> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Perfil(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          //Text('${auth.currentUser?.displayName}',),
          UserAccountsDrawerHeader(
            accountName: Text(
              '${auth.currentUser?.displayName}',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            accountEmail: Text(
              '${auth.currentUser?.email}',
              style: const TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15.0),
            ),
            currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('${auth.currentUser?.photoURL}')),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 114, 63),
            ),
          ),
          Ink(
            child: ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.black54,
                size: 30,
              ),
              title: const Text(
                "Perfil",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    color: Colors.black54),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Perfil()));
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black54,
              size: 30,
            ),
            title: Text(
              "LogOut",
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Colors.black54),
            ),
            onTap: () {
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
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
            },
          ),
        ],
      ),
    );
  }
}
