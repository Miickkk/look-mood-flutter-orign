import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilAmigoView extends StatelessWidget {
  final String nome;

  PerfilAmigoView({super.key, required this.nome});

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);

  final List<IconData> roupas = [
    Icons.checkroom,
    Icons.shopping_bag,
    Icons.style,
    Icons.emoji_people,
  ];

  final List<String> musicasFavoritas = [
    "Starboy – The Weeknd",
    "Houdini – Dua Lipa",
    "Die For You – The Weeknd",
    "Greedy – Tate McRae",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 25),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, _) {
              return CustomPaint(
                painter: _BackgroundPainter(
                  animationValue: value,
                  roxoPrincipal: roxoPrincipal,
                  roxoEscuro: roxoEscuro,
                ),
                child: Container(),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 20),

                  Text(
                    nome,
                    style: GoogleFonts.lora(
                      color: Colors.white70,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    child: Icon(
                      Icons.person,
                      color: Colors.white70,
                      size: 55,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Estilos:",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: roupas.map((icon) {
                        return Icon(
                          icon,
                          color: Colors.white,
                          size: 40,
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Músicas favoritadas:",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                      itemCount: musicasFavoritas.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            musicasFavoritas[index],
                            style: GoogleFonts.lora(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // BOTÃO ADICIONAR AMIGO - BRANCO CINTILANTE
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.3),
                      foregroundColor: Colors.white,
                      shadowColor: Colors.white.withOpacity(0.5),
                      elevation: 8,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true); // Retorna true para indicar que adicionou
                    },
                    child: Text(
                      "Adicionar amigo",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Apenas voltar
                    },
                    child: Text(
                      "Voltar",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FUNDO ANIMADO
class _BackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color roxoPrincipal;
  final Color roxoEscuro;

  _BackgroundPainter({
    required this.animationValue,
    required this.roxoPrincipal,
    required this.roxoEscuro,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double shift = sin(animationValue * 5 * pi) * 0.5 + 0.5;

    final Paint bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color.lerp(roxoEscuro, roxoPrincipal, shift * 0.6)!,
          Color.lerp(roxoPrincipal, Colors.deepPurpleAccent, shift * 0.4)!,
        ],
        begin: Alignment(-0.5 + shift, -1 + shift * .8),
        end: Alignment(1 - shift * .8, .8 - shift * .5),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
