import 'dart:convert';
import 'package:assistence_app/models/materia.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class MatterDetailPage extends StatefulWidget {
  final Materia materia;
  final List<String> dias;

  const MatterDetailPage({Key? key, required this.materia, required this.dias})
      : super(key: key);

  @override
  _MatterDetailPageState createState() => _MatterDetailPageState();
}

class _MatterDetailPageState extends State<MatterDetailPage> {
  late Future<DateTime> _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = _getCurrentDate();
  }

  Future<DateTime> _getCurrentDate() async {
    final response =
        await http.get(Uri.parse('http://worldtimeapi.org/api/ip'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DateTime.parse(data['utc_datetime']);
    } else {
      throw Exception('Failed to load current date');
    }
  }

  DateTime getPreviousWeekday(
      DateTime currentDate, List<String> targetWeekdays) {
    // Obtiene el índice del día de la semana actual
    int currentWeekdayIndex = currentDate.weekday;

    // Busca el día de la semana más cercano de la lista objetivo
    int nearestWeekdayIndex = currentWeekdayIndex;
    for (var weekday in targetWeekdays) {
      int weekdayIndex = _getWeekdayIndex(weekday);
      int difference = weekdayIndex - currentWeekdayIndex;
      if (difference <= 0) {
        difference += 7;
      }
      if (difference < nearestWeekdayIndex - currentWeekdayIndex) {
        nearestWeekdayIndex = weekdayIndex;
      }
    }
    // Resta días hasta llegar al día de la semana más cercano de la lista objetivo
    while (currentDate.weekday != nearestWeekdayIndex) {
      currentDate = currentDate.subtract(Duration(days: 1));
    }

    return currentDate;
  }

  int _getWeekdayIndex(String weekday) {
    switch (weekday.toLowerCase()) {
      case 'lunes':
        return 1;
      case 'martes':
        return 2;
      case 'miércoles':
        return 3;
      case 'jueves':
        return 4;
      case 'viernes':
        return 5;
      case 'sábado':
        return 6;
      case 'domingo':
        return 7;
      default:
        throw Exception('Invalid weekday');
    }
  }

  List<DateTime> _getDates(DateTime currentDate) {
    List<DateTime> dates = [];
    dates.add(DateTime.now());
    return dates;
  }

  DateTime getNextWeekday(DateTime currentDate, int targetWeekday) {
    int currentWeekday = currentDate.weekday;
    int difference = targetWeekday - currentWeekday;

    // Si la diferencia es negativa, añadimos días suficientes para llegar al próximo día de la semana
    if (difference <= 0) {
      difference += 7;
    }

    return currentDate.add(Duration(days: difference));
  }

  DateTime _getNearestDay(DateTime currentDate) {
    // Buscar el día más cercano en la lista de días
    DateTime nearestDay = currentDate;
    int minDifference =
        7; // Inicializar con un número mayor que la cantidad de días en una semana
    for (final day in widget.dias) {
      final dayIndex = _getWeekdayIndex(day);
      final difference = (dayIndex - currentDate.weekday).abs();
      if (difference < minDifference) {
        minDifference = difference;
        nearestDay = currentDate.add(Duration(days: difference));
      }
    }
    return nearestDay;
  }

  bool _isNearestDate(DateTime currentDate, DateTime date) {
    final today =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    final diffCurrent = date.difference(today).inDays;
    final diffNext =
        currentDate.add(Duration(days: 1)).difference(today).inDays;
    return diffCurrent <= diffNext;
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalles de ${widget.materia.nombre}')),
      body: FutureBuilder<DateTime>(
        future: _currentDate,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final currentDate = snapshot.data!;
            final dates = _getDates(currentDate);
            return ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final date = dates[index];
                final isNearestDate = _isNearestDate(currentDate, date);
                return ListTile(
                  title: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssistenceDetail(date: date),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        isNearestDate ? Colors.green : Colors.blue,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _getWeekdayName(date.weekday),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class AssistenceDetail extends StatelessWidget {
  final DateTime date;

  const AssistenceDetail({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalles de Asistencia')),
      body: Center(
        child: Text(
          'Detalles para el ${date.day}/${date.month}/${date.year}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
