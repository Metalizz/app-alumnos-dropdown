class materias {
  //Esta es la clase modelo de materias que se usa dentro de la clase alumnos
  final int actividad, tipo_exa, periodo, cicloescolar, etapa;
  final String descripcion, tipo_exadesc, calificacion, nom_titular;

  materias(
      this.descripcion,
      this.tipo_exadesc,
      this.calificacion,
      this.nom_titular,
      this.actividad,
      this.tipo_exa,
      this.periodo,
      this.cicloescolar,
      this.etapa);

  materias.fromJson(Map<String, dynamic> json)
      //Este constructor crea un objeto materia en base
      //a una matriz generada de un json
      : descripcion = json['descripcion'],
        tipo_exadesc = json['tipoexadesc'],
        calificacion = json['calificacion'],
        nom_titular = reformatearNombre(json['nomtitular']),
        actividad = json['actividad'],
        tipo_exa = json['tipo_exa'],
        periodo = json['periodo'],
        cicloescolar = json['cicloescolar'],
        etapa = json['etapa'];

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
