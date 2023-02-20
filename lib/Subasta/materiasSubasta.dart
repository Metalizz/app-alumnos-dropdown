class materiasSubasta {
  int activado, actividad, clavegrupo, cupo, grupo, lugar, pinta, subGrupo;
  String descripcion, status, tipoDescripcion, validez;
  bool por_paquetes;

  materiasSubasta(
      this.activado,
      this.actividad,
      this.clavegrupo,
      this.cupo,
      this.descripcion,
      this.grupo,
      this.lugar,
      this.pinta,
      this.por_paquetes,
      this.status,
      this.subGrupo,
      this.tipoDescripcion,
      this.validez);

  materiasSubasta.fromJson(Map<String, dynamic> json)
      : activado = json['activado'],
        actividad = json['actividad'],
        clavegrupo = json['clavegrupo'],
        cupo = json['cupo'],
        descripcion = json['descripcion'],
        grupo = json['grupo'],
        lugar = json['lugar'],
        pinta = json['pinta'],
        por_paquetes = json['por_paquetes'],
        status = json['status'],
        subGrupo = json['subgrupo'],
        tipoDescripcion = json['tipodescripcion'],
        validez = json['validez'];
}
