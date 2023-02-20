import 'materias.dart';

class alumnos {
  //Esta es la clase modelo de un alumno deacuerdo a como es representado en el json
  final int expediente,
      matriculaMunicipio,
      matricula,
      unidadAcademica,
      programaEstudios;
  final String nombreAlumno,
      unidadAcademicaDesc,
      programaEstudiosDesc,
      planEstudios;
  final List<materias> listaMaterias;

  alumnos(
      this.expediente,
      this.matriculaMunicipio,
      this.matricula,
      this.nombreAlumno,
      this.unidadAcademica,
      this.unidadAcademicaDesc,
      this.programaEstudios,
      this.programaEstudiosDesc,
      this.planEstudios,
      this.listaMaterias);

  alumnos.fromJson(Map<String, dynamic> json)
      //Este constructor construye el objeto en base a la matriz obtenida de un json
      : expediente = json['expediente'],
        matriculaMunicipio = json['matriculaMunicipio'],
        matricula = json['matricula'],
        nombreAlumno = json['nombreAlumno'],
        unidadAcademica = json['unidadAcademica'],
        unidadAcademicaDesc = json['unidadAcademicaDesc'],
        programaEstudios = json['programaEstudios'],
        programaEstudiosDesc = json['programaEstudiosDesc'],
        planEstudios = json['planEstudios'],
        listaMaterias = crearListaMaterias(json['materias']);
}

List<materias> crearListaMaterias(List<dynamic> jsonMap) {
  print("creando lista materias");
  //este metodo crea la lista de materias del objeto en base a la matriz dentro de la matriz de alumno
  List<materias> listaMaterias = [];
  materias materia;
  if (jsonMap.isNotEmpty) {
    for (var element in jsonMap) {
      materia = materias.fromJson(element);
      listaMaterias.add(materia);
    }
  }
  return listaMaterias;
}
