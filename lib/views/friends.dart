import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:look_mood/views/friends_inside.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AmigosView extends StatefulWidget {
  const AmigosView({super.key});

  @override
  State<AmigosView> createState() => _AmigosViewState();
}

class _AmigosViewState extends State<AmigosView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _controller;

  bool _mostrarBusca = false;

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);

  final List<String> nomesAmigos = [
    "Maria Luiza",
    "Kamili Martins",
    "Max",
    "Antonio",
    "Bola",
    "Tuti",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FUNDO ANIMADO
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _BackgroundPainter(
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
                  const SizedBox(height: 25),

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

                      // título centralizado
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Look & Mood",
                              style: GoogleFonts.cinzelDecorative(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 5.5,
                              ),
                            ),
                            Text(
                              "Encontre seus amigos aqui!",
                              style: GoogleFonts.lora(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // espaço para balancear o botão
                      const SizedBox(width: 33),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // BOTÃO ADICIONAR AMIGOS
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _mostrarBusca = !_mostrarBusca;
                      });
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: roxoPrincipal,
                          radius: 22,
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Adicionar Amigos",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CAMPO DE PESQUISA
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _mostrarBusca
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Procurar amigos...',
                                hintStyle: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.white70,
                                ),
                                filled: true,
                                fillColor: roxoPrincipal.withOpacity(0.4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 25),

                  // LISTA DE AMIGOS
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 20,
                          ),
                      itemCount: nomesAmigos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PerfilAmigoView(nome: nomesAmigos[index]),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.1,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white.withOpacity(0.7),
                                      size: 35,
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: roxoPrincipal,
                                    child: const Icon(
                                      Icons.visibility,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                nomesAmigos[index],
                                style: GoogleFonts.lora(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
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
        begin: Alignment(-0.5 + shift, -1.0 + shift * 0.8),
        end: Alignment(1.0 - shift * 0.8, 0.8 - shift * 0.5),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
