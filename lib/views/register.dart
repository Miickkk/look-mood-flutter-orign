import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  final _emailField = TextEditingController();
  final _senhaField = TextEditingController();
  final _confSenhaField = TextEditingController();
  final _authController = FirebaseAuth.instance;

  bool _senhaOculta = true;
  bool _confSenhaOculta = true;
  late AnimationController _controller;

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);
  final Color roxoClaro = Colors.deepPurpleAccent;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailField.dispose();
    _senhaField.dispose();
    _confSenhaField.dispose();
    super.dispose();
  }

  void _registrar() async {
    if (_senhaField.text != _confSenhaField.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF241536),
          content: Text("As senhas não coincidem"),
        ),
      );
      return;
    }

    try {
      await _authController.createUserWithEmailAndPassword(
        email: _emailField.text.trim(),
        password: _senhaField.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF241536),
          content: Text("Conta criada com sucesso!"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF241536),
          content: Text("Falha ao registrar: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: roxoEscuro,
      body: Stack(
        children: [
          // 🔹 Navbar animada
          SizedBox(
            height: 180,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: NavbarWavePainter(
                    animationValue: _controller.value,
                    roxoPrincipal: roxoPrincipal,
                    roxoEscuro: roxoEscuro,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: const Offset(0, -20),
                      child: Text(
                        "Registrar",
                        style: GoogleFonts.cinzelDecorative(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔹 Conteúdo principal
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailField,
                      cursorColor: roxoPrincipal,
                      style: TextStyle(
                        color: roxoPrincipal,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: roxoEscuro.withOpacity(0.6),
                        labelText: "Email",
                        labelStyle: TextStyle(color: roxoClaro),
                        floatingLabelStyle: TextStyle(color: roxoPrincipal),
                        prefixIcon: Icon(Icons.email_outlined, color: roxoPrincipal),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: roxoPrincipal, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: roxoClaro, width: 1.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _senhaField,
                      obscureText: _senhaOculta,
                      cursorColor: roxoPrincipal,
                      style: TextStyle(
                        color: roxoPrincipal,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: roxoEscuro.withOpacity(0.6),
                        labelText: "Senha",
                        labelStyle: TextStyle(color: roxoClaro),
                        floatingLabelStyle: TextStyle(color: roxoPrincipal),
                        prefixIcon: Icon(Icons.lock_outline, color: roxoPrincipal),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _senhaOculta = !_senhaOculta;
                            });
                          },
                          icon: Icon(
                            _senhaOculta
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: roxoPrincipal,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: roxoPrincipal, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: roxoClaro, width: 1.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _confSenhaField,
                      obscureText: _confSenhaOculta,
                      cursorColor: roxoPrincipal,
                      style: TextStyle(
                        color: roxoPrincipal,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: roxoEscuro.withOpacity(0.6),
                        labelText: "Confirmar Senha",
                        labelStyle: TextStyle(color: roxoClaro),
                        floatingLabelStyle: TextStyle(color: roxoPrincipal),
                        prefixIcon: Icon(Icons.lock_outline, color: roxoPrincipal),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _confSenhaOculta = !_confSenhaOculta;
                            });
                          },
                          icon: Icon(
                            _confSenhaOculta
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: roxoPrincipal,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: roxoPrincipal, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: roxoClaro, width: 1.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: roxoPrincipal,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _registrar,
                        child: const Text(
                          "Registrar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Já tem uma conta? Faça login!",
                        style: TextStyle(
                          color: roxoPrincipal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Mesmo efeito da navbar do Login e Home
class NavbarWavePainter extends CustomPainter {
  final double animationValue;
  final Color roxoPrincipal;
  final Color roxoEscuro;

  NavbarWavePainter({
    required this.animationValue,
    required this.roxoPrincipal,
    required this.roxoEscuro,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [roxoPrincipal.withOpacity(0.8), roxoEscuro.withOpacity(0.9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path path = Path();
    final double waveHeight = 15;
    final double speed = animationValue * 2 * pi;

    path.moveTo(0, size.height * 0.7);

    for (double i = 0; i <= size.width; i++) {
      path.lineTo(i, size.height * 0.7 + sin((i / 40) + speed) * waveHeight);
    }

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavbarWavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
