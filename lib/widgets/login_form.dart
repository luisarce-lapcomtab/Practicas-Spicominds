part of 'widgets.dart';

class LoginForm extends StatefulWidget {
  final Function(String) showMessage;
  const LoginForm({super.key, required this.showMessage});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    final String email = _emailCtrl.text.trim();
    final String password = _passCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      widget.showMessage(
          "Por favor, ingrese su correo electrónico y contraseña.");
      return;
    }
    final result =
        await AuthService().signInWithEmailandPassword(email, password);
    if (result.success) {
      // Actualiza el estado de inicio de sesión
      await PreferencesService().updateLoginStatus(true);

      bool isProfessionalDataValid =
          await PreferencesService().areProfessionalDataValid();

      if (isProfessionalDataValid) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const DetailsProfessionalProfile()),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyPageState()),
        );
      }
    } else {
      widget.showMessage("Error: ${result.errorMessage}");
    }
    _emailCtrl.clear();
    _passCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Hero(
            tag: 'icon',
            child: Image(
              image: AssetImage('assets/icon.png'),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              'INICIAR SESIÓN',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 30),
          CustomInput(
            icon: Icons.email,
            placerholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: _emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_rounded,
            placerholder: 'Contraseña',
            textController: _passCtrl,
            isPaassword: true,
          ),
          const SizedBox(height: 15),
          CustomButton(text: 'Iniciar Sesion', onPressed: () => login(context)),
          const SizedBox(height: 10),
          const AuthOptionLabels(
            ruta: 'selector-page',
            titulo: 'No tienes cuenta?',
            subtitulo: 'Crear una ahora!',
          ),
        ],
      ),
    );
  }
}
