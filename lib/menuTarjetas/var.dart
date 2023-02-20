import 'package:boletaproto2new/Boletas/alumnos.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var matriculaAlumno;
var carreraAlumno;
var estadoAlumno;
//late alumnos alumnoExpediente;
bool isAlumnoExpedienteEmpty = false;



//var secret;
//var tknAlumno;

class BlackBox {
  static const _storage = FlutterSecureStorage();
  static const String _tokenAlumno = "tknAlumno", _tokenGoogle = "tknGoogle";

  static Future<void> setToken(String secret) async {
    await _storage.write(key: _tokenAlumno, value: secret);
  }

  static Future<String?> getServiceToken() async {
    return await _storage.read(key: _tokenAlumno);
  }

  static void setTokenGoogle(String secret) async {
    await _storage.write(key: _tokenGoogle, value: secret);
  }

  static Future<String?> getTokenGoogle() async {
    return await _storage.read(key: _tokenGoogle);
  }

  static void nukeEm() {
    _storage.deleteAll();
  }
}
