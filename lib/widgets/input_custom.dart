part of 'widgets.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placerholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPaassword;
  const CustomInput(
      {super.key,
      required this.icon,
      required this.placerholder,
      required this.textController,
      this.keyboardType = TextInputType.text,
      this.isPaassword = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(25),
        /* boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]*/
      ),
      child: TextField(
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        controller: textController,
        autocorrect: false,
        keyboardType: keyboardType,
        obscureText: isPaassword, //para ocultar el texto
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: placerholder,
            hintStyle: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class CustomInputReg extends StatelessWidget {
  final IconData icon;
  final String placerholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPaassword;
  const CustomInputReg(
      {super.key,
      required this.icon,
      required this.placerholder,
      required this.textController,
      this.keyboardType = TextInputType.text,
      this.isPaassword = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      autocorrect: false,
      keyboardType: keyboardType,
      obscureText: isPaassword, //para ocultar el texto
      decoration: InputDecoration(
          labelText: placerholder,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          focusedBorder: InputBorder.none,
          border: InputBorder.none),
    );
  }
}

class CustomInputPass extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final TextEditingController textController;
  final bool isPassword;
  final bool isPasswordVisible;
  final void Function() togglePasswordVisibility;
  const CustomInputPass(
      {super.key,
      required this.icon,
      required this.labelText,
      required this.textController,
      required this.isPassword,
      required this.isPasswordVisible,
      required this.togglePasswordVisibility});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // style: const TextStyle(color: Colors.deepPurple),
      controller: textController,
      autocorrect: false,
      keyboardType: TextInputType.text,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
        suffixIcon: IconButton(
          color: Colors.deepPurple,
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: togglePasswordVisibility,
        ),
      ),
    );
  }
}
