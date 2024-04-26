import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Datos de COVID-19',
      home: CovidScreen(), // Pantalla para mostrar datos de COVID-19
    );
  }
}

class CovidScreen extends StatefulWidget {
  @override
  _CovidScreenState createState() => _CovidScreenState();
}

class _CovidScreenState extends State<CovidScreen> {
  int? _positiveCases; // Casos positivos
  int? _currentHospitalizations; // Hospitalizaciones actuales
  int? _deaths; // Muertes
  int? _recovered; // Casos recuperados
  int? _positiveIncrease; // Casos actuales (nuevos)
  bool _isLoading = true; // Indicador de carga mientras se obtiene la respuesta

  @override
  void initState() {
    super.initState();
    _fetchCovidData(); // Obtener datos de COVID-19
  }

  Future<void> _fetchCovidData() async {
    try {
      final response = await http.get(Uri.parse(
              "https://api.covidtracking.com/v1/us/current.json") // Solicitud a la API de COVID Tracking
          );

      if (response.statusCode == 200) {
        // Si la solicitud es exitosa
        final covidData = json.decode(response.body);
        setState(() {
          _positiveCases = covidData[0]['positive']; // Casos positivos
          _currentHospitalizations = covidData[0]
              ['hospitalizedCurrently']; // Hospitalizaciones actuales
          _deaths = covidData[0]['death']; // Muertes
          _recovered = covidData[0]['recovered']; // Casos recuperados
          _positiveIncrease =
              covidData[0]['positiveIncrease']; // Casos actuales (nuevos)
          _isLoading = false; // Detener el indicador de carga
        });
      } else {
        // Si la solicitud falla
        throw Exception("Error al obtener datos de COVID-19");
      }
    } catch (e) {
      // Manejo de excepciones
      setState(() {
        _isLoading = false; // Detener el indicador de carga
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de COVID-19'), // Título de la aplicación
      ),
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator() // Indicador de carga mientras se espera la respuesta
              : Column(
                  // Mostrar datos en una columna
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // Casos positivos
                      'Casos positivos: $_positiveCases',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      // Hospitalizaciones actuales
                      'Hospitalizaciones actuales: $_currentHospitalizations',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      // Muertes
                      'Muertes: $_deaths',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      // Casos recuperados
                      'Casos recuperados: $_recovered',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      // Casos actuales (nuevos)
                      'Casos actuales: $_positiveIncrease',
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                      // Botón para actualizar datos
                      onPressed:
                          _fetchCovidData, // Llama a la función para obtener datos
                      child: Text("Actualizar"), // Texto del botón
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
