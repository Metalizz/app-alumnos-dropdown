import 'dias.dart';

class materiaHorario {
  String descripcion,
      desc_activ,
      desc_espacio,
      nombrecompleto,
      subgrupo,
      edificio;
  int actividad, clavegrupo, creditos, etapa, grupo, periodo_estudios, titular;
  List<dias> listDias;

  materiaHorario(
      this.listDias,
      this.actividad,
      this.clavegrupo,
      this.creditos,
      this.descripcion,
      this.desc_activ,
      this.desc_espacio,
      this.edificio,
      this.etapa,
      this.grupo,
      this.nombrecompleto,
      this.periodo_estudios,
      this.subgrupo,
      this.titular);

  materiaHorario.fromJson(Map<String, dynamic> json)
      : listDias = _crearListaDias(json['listDias']),
        actividad = json['v_actividad'],
        clavegrupo = json['v_clavegrupo'],
        creditos = json['v_creditos'],
        descripcion = json['v_descripcion'],
        desc_activ = json['v_desc_activ'],
        desc_espacio = json['v_desc_espacio'],
        edificio = json['v_edificio'],
        etapa = json['v_etapa'],
        grupo = json['v_grupo'],
        nombrecompleto = json['v_nombrecompleto'],
        periodo_estudios = json['v_periodo_estudios'],
        subgrupo = json['v_subgrupo'],
        titular = json['v_titular'];
}

List<dias> _crearListaDias(var json) {
  List<dias> lista = [];
  if (json == null) {
    return lista;
  } else {
    for (var element in json) {
      dias d = dias.fromJson(element);
      lista.add(d);
    }
    return lista;
  }
}
