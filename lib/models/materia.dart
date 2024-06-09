export 'materia.dart';

class Materia {
  final String nombre;
  final String moduloAula;
  final String horario;
  final List<String> dias;

  Materia({
    required this.nombre,
    required this.moduloAula,
    required this.horario,
    required this.dias,
  });
}
