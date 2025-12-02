// lib/views/cabinet_inside.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:look_mood/controller/favorites_manager.dart';

final Map<String, List<Map<String, dynamic>>> modelosPorSubtipo = {
  "jaqueta jeans": [
    {"nome": "Jaqueta jeans 1", "foto": "assets/roupas/a.1.png"},
    {"nome": "Jaqueta jeans 2", "foto": "assets/roupas/a.2.png"},
  ],
  "casaco longo": [
    {"nome": "Casaco longo 1", "foto": "assets/roupas/a.3.png"},
    {"nome": "Casaco longo 2", "foto": "assets/roupas/a.4.png"},
  ],
};

class OpcaoRoupaView extends StatefulWidget {
  final String nomeRoupa;

  const OpcaoRoupaView({
    super.key,
    required this.nomeRoupa,
  });

  @override
  State<OpcaoRoupaView> createState() => _OpcaoRoupaViewState();
}

class _OpcaoRoupaViewState extends State<OpcaoRoupaView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);
  final FavoritesManager fav = FavoritesManager();

  late List<Map<String, dynamic>> listaOpcoesCorrigida;

  @override
  void initState() {
    super.initState();

    final String chave = widget.nomeRoupa.trim().toLowerCase();
    listaOpcoesCorrigida = modelosPorSubtipo[chave] ?? [];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCard(Map<String, dynamic> opc) {
    final String nome = opc['nome'] ?? 'Sem nome';
    final String foto = opc['foto'] ?? '';
    final bool isFav = fav.modelos[nome] ?? false;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color.fromARGB(255, 212, 198, 255).withOpacity(0.55),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: foto.isNotEmpty
                    ? Image.asset(
                        foto,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          height: 120,
                          color: Colors.purple.withOpacity(0.4),
                        ),
                      )
                    : Container(
                        height: 140,
                        color: Colors.purple.withOpacity(0.4),
                      ),
              ),
              const SizedBox(height: 10),
              Text(
                nome,
                style: GoogleFonts.lora(
                  color: Color.fromRGBO(57, 30, 136, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
            ],
          ),

          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  fav.toggleModelo(nome);
                });
              },
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.pink : Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
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
                painter: SmoothMovingBackgroundPainter(
                  animationValue: _controller.value,
                  roxoEscuro: roxoEscuro,
                  roxoPrincipal: roxoPrincipal,
                ),
                child: Container(),
              );
            },
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white30),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.nomeRoupa,
                              style: GoogleFonts.cinzelDecorative(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Escolha um modelo",
                              style: GoogleFonts.lora(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 42),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: listaOpcoesCorrigida.isEmpty
                      ? const Center(
                          child: Text(
                            "Nenhum modelo encontrado",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      : GridView.count(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: listaOpcoesCorrigida
                              .map((opc) => _buildCard(opc))
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// FUNDO (mesmo painter usado no cabinet.dart)
class SmoothMovingBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color roxoPrincipal;
  final Color roxoEscuro;

  SmoothMovingBackgroundPainter({
    required this.animationValue,
    required this.roxoPrincipal,
    required this.roxoEscuro,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double shift = sin(animationValue * 5 * pi) * 0.5 + 0.5;

    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color.lerp(roxoEscuro, roxoPrincipal, shift * 0.6)!,
          Color.lerp(roxoPrincipal, Colors.deepPurpleAccent, shift * 0.4)!,
        ],
        begin: Alignment(-0.5 + shift, -0.8 + shift * 0.4),
        end: Alignment(1.0 - shift * 0.7, 1.0 - shift * 0.5),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
