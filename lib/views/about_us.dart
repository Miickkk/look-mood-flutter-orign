import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SobreNosView extends StatefulWidget {
  const SobreNosView({super.key});

  @override
  State<SobreNosView> createState() => _SobreNosViewState();
}

class _SobreNosViewState extends State<SobreNosView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);

  @override
  void initState() {
    super.initState();
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

  Widget _buildImagePlaceholder({
    required double width,
    required double height,
    double radius = 15.0,
    String? assetPath,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white54, width: 2),
        color: Colors.white.withOpacity(0.08),
        image: assetPath != null
            ? DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover)
            : null,
      ),
      child: assetPath == null
          ? Center(
              child: Icon(Icons.photo_camera, color: Colors.white70, size: 40),
            )
          : null,
    );
  }

  Widget _buildInfoCard(IconData icon, String titulo, String texto) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.13),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 42),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: GoogleFonts.cinzelDecorative(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            texto,
            style: GoogleFonts.lora(color: Colors.white70, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = (MediaQuery.of(context).size.width - 50) * 0.5;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                painter: SmoothMovingBackgroundPainter(
                  animationValue: _controller.value,
                  roxoPrincipal: roxoPrincipal,
                  roxoEscuro: roxoEscuro,
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
                              "Sobre Nós",
                              style: GoogleFonts.cinzelDecorative(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Conheça o App Look & Mood!",
                              style: GoogleFonts.lora(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 55),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        _buildImagePlaceholder(
                          width: double.infinity,
                          height: 150,
                          radius: 20,
                          assetPath: 'assets/img/banner4.png',
                        ),
                        const SizedBox(height: 25),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                Icons.lightbulb_outline,
                                "Nosso Conceito",
                                "O Look & Mood é um app criado para todas as idades, onde você escolhe seu humor em estilos de roupas, combina com um look e ainda adiciona música para deixar tudo mais divertido!",
                              ),
                            ),
                            const SizedBox(width: 25),
                            _buildImagePlaceholder(
                              width: 150,
                              height: 250,
                              radius: 15,
                              assetPath: 'assets/img/banner.png',
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImagePlaceholder(
                              width: 190,
                              height: 200,
                              radius: 100,
                              assetPath: 'assets/img/banner2.png',
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              child: _buildInfoCard(
                                Icons.people,
                                "Quem Criou",
                                "Este aplicativo foi criado pela desenvolvedora Anick Lima, com pariticipação de Maria Luiza no protótipo que juntaram criatividade, design e programação para criar uma experiência única.",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 35),

                        _buildInfoCard(
                          Icons.favorite,
                          "Nossa Missão",
                          "Queremos que cada usuário sinta liberdade para se expressar, explorar estilos, criar combinações e se divertir ao máximo enquanto usa o Look & Mood.",
                        ),

                        const SizedBox(height: 35),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                Icons.touch_app,
                                "Como Funciona?",
                                "Você escolhe uma categoria, seleciona roupas, salva modelos, organiza seu guarda-roupa e ainda pode convidar amigos para interagir e comparar looks.",
                              ),
                            ),
                            const SizedBox(width: 25),
                            _buildImagePlaceholder(
                              width: 150,
                              height: 250,
                              radius: 15,
                              assetPath: 'assets/img/banner3.png',
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
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

    final Paint bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color.lerp(roxoEscuro, roxoPrincipal, shift * 0.6)!,
          Color.lerp(roxoPrincipal, const Color(0xFF7C4DFF), shift * 0.4)!,
        ],
        begin: Alignment(-0.5 + shift, -1.0 + shift * 0.8),
        end: Alignment(1.0 - shift * 0.8, 0.8 - shift * 0.5),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }

  @override
  bool shouldRepaint(covariant SmoothMovingBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
