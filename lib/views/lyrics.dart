import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LetraMusicaView extends StatefulWidget {
  final String titulo;
  final String artista;
  final String letra;

  const LetraMusicaView({
    super.key,
    required this.titulo,
    required this.artista,
    required this.letra,
  });

  @override
  State<LetraMusicaView> createState() => _LetraMusicaViewState();
}

class _LetraMusicaViewState extends State<LetraMusicaView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color roxoPrincipal = const Color(0xFF4A1F9F);
  final Color roxoEscuro = const Color(0xFF1A0E2A);
  final Color roxoProfundo = const Color(0xFF2D0F4C);
  final Color roxoNeblina = const Color(0xFF6F3BAF);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                painter: SmoothLyricsBackground(
                  animationValue: _controller.value,
                  roxoPrincipal: roxoPrincipal,
                  roxoEscuro: roxoEscuro,
                ),
                child: Container(),
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white30, width: 1),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Text(
                          widget.titulo,
                          style: GoogleFonts.cinzelDecorative(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Text(
                    widget.artista,
                    style: GoogleFonts.lora(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.letra,
                        style: GoogleFonts.lora(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 45),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmoothLyricsBackground extends CustomPainter {
  final double animationValue;
  final Color roxoPrincipal;
  final Color roxoEscuro;

  SmoothLyricsBackground({
    required this.animationValue,
    required this.roxoPrincipal,
    required this.roxoEscuro,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double s = sin(animationValue * pi * 2);

    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color.lerp(roxoEscuro, roxoPrincipal, 0.6 + s * 0.2)!,
          Color.lerp(roxoPrincipal, const Color(0xFF6F3BAF), 0.20 + s * 0.20)!,
          Color.lerp(
            const Color(0xFF2D0F4C),
            const Color(0xFF4A1F9F),
            0.4 + s * 0.3,
          )!,
        ],

        begin: Alignment(-1 + s, -1),
        end: Alignment(1 - s, 1),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant SmoothLyricsBackground oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
