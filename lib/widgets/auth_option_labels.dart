part of 'widgets.dart';

class AuthOptionLabels extends StatelessWidget {
  final String ruta;
  final String titulo;
  final String subtitulo;
  const AuthOptionLabels(
      {super.key,
      required this.ruta,
      required this.titulo,
      required this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Text(titulo,
              style: const TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.w500)),
          GestureDetector(
              child: Text(subtitulo,
                  style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pushReplacementNamed(context, ruta)),
        ],
      ),
    );
  }
}
