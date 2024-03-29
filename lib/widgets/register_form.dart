part of 'widgets.dart';

class RegisterForm extends StatefulWidget {
  final Function(String) showMessage;
  final bool isUser;
  const RegisterForm(
      {super.key, required this.showMessage, required this.isUser});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameCtrl = TextEditingController();
  final _ceduCtrl = TextEditingController();
  final _telfCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirCtrl = TextEditingController();

  bool _isPasswordVisible = false;
  late final String _rol;
  @override
  void initState() {
    _rol = widget.isUser ? 'usuario' : 'especialista';
    super.initState();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _ceduCtrl.dispose();
    _telfCtrl.dispose();
    _confirCtrl.dispose();
    super.dispose();
  }

  Future<void> register(BuildContext context) async {
    final String email = _emailCtrl.text.trim();
    final String password = _passCtrl.text.trim();
    final String cedula = _ceduCtrl.text.trim();

    if (password != _confirCtrl.text.trim()) {
      setState(() {
        widget.showMessage(
            "Por favor, asegúrate de ingresar la misma contraseña en ambos campos.");
      });
      return;
    }

    if (email.isEmpty || password.isEmpty || cedula.isEmpty) {
      setState(() {
        widget.showMessage("Por favor, complete todos los campos.");
      });
      return;
    }

    RegistrationResult result = await AuthService()
        .createUserWithEmailandPassword(email, password, _nameCtrl.text.trim(),
            _telfCtrl.text.trim(), cedula, widget.isUser);

    if (result.success) {
      setState(() {
        widget.showMessage("¡Registro exitoso!");
      });

      await Future.delayed(const Duration(seconds: 1));

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
        context,
        'login-page',
      );
    } else {
      widget.showMessage("Error: ${result.errorMessage}");
      _passCtrl.clear();
      _confirCtrl.clear();
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,
            'Registro de $_rol',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 27),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
            child: Text(
              textAlign: TextAlign.center,
              'Configura tu perfil completando los siguientes datos',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.deepPurple),
              ),
            ),
          ),
          const SizedBox(height: 15),
          CustomInputReg(
              icon: Icons.person,
              placerholder: 'Nombres',
              textController: _nameCtrl),
          CustomInputReg(
              icon: Icons.phone,
              placerholder: 'Telefono',
              keyboardType: TextInputType.number,
              textController: _telfCtrl),
          CustomInputReg(
              icon: widget.isUser ? Icons.contact_emergency : Icons.school,
              placerholder:
                  widget.isUser ? 'Cedula' : 'N° de registro de titulo',
              keyboardType: TextInputType.number,
              textController: _ceduCtrl),
          CustomInputReg(
              icon: Icons.email,
              placerholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: _emailCtrl),
          CustomInputPass(
            icon: Icons.lock,
            labelText: 'Contraseña *',
            textController: _passCtrl,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            togglePasswordVisibility: togglePasswordVisibility,
          ),
          CustomInputPass(
            icon: Icons.lock_rounded,
            labelText: 'Confirmar Contraseña *',
            textController: _confirCtrl,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            togglePasswordVisibility: togglePasswordVisibility,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Registrarme',
            onPressed: () => register(context),
          ),
          const SizedBox(height: 10),
          const AuthOptionLabels(
            ruta: 'login-page',
            titulo: 'Ya tienes cuenta?',
            subtitulo: 'Ingresa ahora!',
          ),
        ],
      ),
    );
  }
}
