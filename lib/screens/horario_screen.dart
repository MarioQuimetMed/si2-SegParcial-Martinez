import 'package:assistence_app/models/materia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorarioScreenPage extends StatefulWidget {
  HorarioScreenPage({super.key});

  static const dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];
  // Lista de materias para cada día
  static List<Materia> materiasPorDia = [
    Materia(
      nombre: 'Sistema de informacion 1',
      moduloAula: 'Aula 1',
      horario: '8:00 - 10:00',
      dias: ['Lunes', 'Miércoles'],
    ),
    Materia(
      nombre: 'Base de datos 2',
      moduloAula: 'Aula 2',
      horario: '18:00 - 20:00',
      dias: ['Martes'],
    ),
    Materia(
      nombre: 'Ingenieria de Software 1',
      moduloAula: 'Aula 3',
      horario: '8:00 - 10:00',
      dias: ['Martes', 'Jueves'],
    ),
  ];

  @override
  State<HorarioScreenPage> createState() => _HorarioScreenPageState();
}

class _HorarioScreenPageState extends State<HorarioScreenPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(height: 20),
            DiasMateriasWidget(),
          ],
        ),
      ),
    );
  }
}

class DiasMateriasWidget extends StatelessWidget {
  const DiasMateriasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: HorarioScreenPage.dias.map((dia) {
        final materiasDelDia = HorarioScreenPage.materiasPorDia
            .where((materia) => materia.dias.contains(dia))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              width: width * 0.25,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  dia,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: materiasDelDia.map((materia) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          materia.nombre,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Aula: ${materia.moduloAula}',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Horario: ${materia.horario}',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}
