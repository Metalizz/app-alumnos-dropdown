/**
 * Este archivo contiene todo los endpoints o servicios que utilizamos en la aplicación.
 */
//const Centinela = "https://apigw.uabc.mx:8243/v1/pass/centinela/";
//const CorreoPass = "https://apigw.uabc.mx:8243/v1/pass/login?correo=";

//PROXY ALUMNOS
const CorreoUABCEstudiante =
    // "https://apigw.uabc.mx:8243/v2/correo-uabc/?correo="; //old endpoint
    "https://apigw.uabc.edu.mx:8243/v1/correo-uabc-movil-alumnos/correo-uabc?correo="; //new endppoint
//No requiere secret

const SERVER_ALUMNO_URL =
//  "https://servicios.uabc.mx:8114/auth/token";  //Old port
    "https://servicios.uabc.mx:8178/auth/token"; //New port

const MATERIAS =
    // "https://apigw.uabc.edu.mx:8243/v1/boleta/?expediente="; //se agrega el numero de expeidnte al final
    "https://apigw.uabc.edu.mx:8243/v1/alumnos-movil/boleta?expediente="; //new endpoint
//Agregar secret al final "&secret=[secret string]"

const HORARIO =
//  "https://apigw.uabc.mx:8243/v1/horario/?expediente="; //Old endpoint
    "https://apigw.uabc.edu.mx:8243/v1/alumnos-movil/horario?expediente="; //new endpoint
//Agregar secret al final "&secret=[secret string]"

const SUBASTA =
    // "https://apigw.uabc.mx:8243/v1/consulta-subasta-movil/?expediente="; //old endpoint
    "https://apigw.uabc.edu.mx:8243/v1/alumnos-movil/consulta-subasta-movil?expediente="; //new endpoint
    //Agregar secret al fnial
    