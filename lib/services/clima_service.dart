import 'dart:convert';
import 'package:http/http.dart' as http;

class ClimaService {
  static const double latitud = 25.6866;
  static const double longitud = -100.3161;

  Future<Map<String, dynamic>> obtenerDatosMonterrey() async {
    final Uri url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=$latitud'
          '&longitude=$longitud'
          '&current=temperature_2m,weather_code'
          '&timezone=America%2FMonterrey',
    );

    final http.Response respuesta = await http.get(url);

    if (respuesta.statusCode != 200) {
      throw Exception(
        'Error al obtener los datos del clima',
      );
    }

    final Map<String, dynamic> datos =
    jsonDecode(respuesta.body);

    final Map<String, dynamic> actual =
    datos['current'];

    final DateTime fechaHora =
    DateTime.parse(actual['time']);

    return {
      'temperatura':
      (actual['temperature_2m'] as num).round(),
      'codigoClima':
      (actual['weather_code'] as num).toInt(),
      'fechaHora': fechaHora,
    };
  }

  String obtenerEmojiClima(int codigo) {
    if (codigo == 0) {
      return '☀️';
    }

    if (codigo == 1 || codigo == 2) {
      return '🌤️';
    }

    if (codigo == 3) {
      return '☁️';
    }

    if (codigo == 45 || codigo == 48) {
      return '🌫️';
    }

    if (codigo >= 51 && codigo <= 67) {
      return '🌧️';
    }

    if (codigo >= 71 && codigo <= 77) {
      return '🌨️';
    }

    if (codigo >= 80 && codigo <= 82) {
      return '🌦️';
    }

    if (codigo >= 95) {
      return '⛈️';
    }

    return '🌤️';
  }

  String formatearFecha(DateTime fecha) {
    final String dia =
    fecha.day.toString().padLeft(2, '0');

    final String mes =
    fecha.month.toString().padLeft(2, '0');

    return '$dia/$mes/${fecha.year}';
  }

  String formatearHora(DateTime fecha) {
    int hora = fecha.hour;

    final String periodo =
    hora >= 12 ? 'PM' : 'AM';

    if (hora == 0) {
      hora = 12;
    } else if (hora > 12) {
      hora -= 12;
    }

    final String minutos =
    fecha.minute.toString().padLeft(2, '0');

    return '$hora:$minutos $periodo';
  }
}