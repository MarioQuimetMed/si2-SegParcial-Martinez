import 'package:assistence_app/models/materia.dart';
import 'package:assistence_app/screens/asistence/matter_screen.dart';
import 'package:flutter/material.dart';

class AssistenceScreenPage extends StatefulWidget {
  const AssistenceScreenPage({super.key});

  @override
  State<AssistenceScreenPage> createState() => _AssistenceScreenPageState();
}

class _AssistenceScreenPageState extends State<AssistenceScreenPage> {
  static List<Materia> materias = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TituloWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: materias.length,
              itemBuilder: (context, index) {
                return CardMateria(materias: materias, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardMateria extends StatelessWidget {
  const CardMateria({
    super.key,
    required this.materias,
    required this.index,
  });

  final List<Materia> materias;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Añade una sombra para dar profundidad al card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            12), // Bordes redondeados para un aspecto más suave
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 20), // Espaciado interno
        leading: const Icon(Icons.bookmark,
            color: Colors.blue), // Icono a la izquierda del título
        title: Text(
          materias[index].nombre,
          style: const TextStyle(
            fontSize: 18, // Tamaño del texto
            fontWeight: FontWeight.bold, // Texto en negrita para resaltar
            color: Colors.black87, // Color del texto
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.blue), // Icono a la derecha del card
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatterDetailPage(
                  materia: materias[index], dias: materias[index].dias),
            ),
          );
        },
      ),
    );
  }
}

class TituloWidget extends StatelessWidget {
  const TituloWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 110, 170, 238),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Materias',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
