class dias {
  String hora_inicial, hora_final, dia;
  int num_dia;
  bool otra_modalidad;

  dias(this.dia, this.num_dia, this.hora_inicial, this.hora_final,
      this.otra_modalidad);

  dias.fromJson(Map<String, dynamic> json)
      : dia = json['v_dia'],
        num_dia = json['v_num_dia'],
        hora_inicial = json['v_hora_inicial'],
        hora_final = json['v_hora_final'],
        otra_modalidad = json['v_otra_modalidad'];
}
