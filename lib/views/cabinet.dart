// lib/views/cabinet.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:look_mood/controller/favorites_manager.dart';
import 'package:look_mood/views/cabinet_inside.dart';
import 'package:look_mood/controller/favorites_manager.dart';

class RoupasView extends StatefulWidget {
  const RoupasView({super.key});

  @override
  State<RoupasView> createState() => _RoupasViewState();
}

class _RoupasViewState extends State<RoupasView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);

  String categoriaSelecionada = "";
  String buscaTexto = "";

  final TextEditingController _searchController = TextEditingController();

  final FavoritesManager fav = FavoritesManager();

  final List<Map<String, dynamic>> categorias = [
    {"nome": "Casacos", "icon": "assets/icons/3.png"},
    {"nome": "Calças", "icon": "assets/icons/4.png"},
    {"nome": "Camisetas", "icon": "assets/icons/2.png"},
    {"nome": "Vestidos", "icon": "assets/icons/1.png"},
    {"nome": "Tênis", "icon": "assets/icons/5.png"},
    {"nome": "Bolsas", "icon": "assets/icons/6.png"},
    {"nome": "Saltos", "icon": "assets/icons/7.png"},
  ];

  final Map<String, List<Map<String, dynamic>>> roupasCategoria = {
    "Casacos": [
      {"nome": "Jaqueta jeans", "icon": "assets/icons/3.1.png"},
      {"nome": "Casaco longo", "icon": "assets/icons/3.2.png"},
    ],
    "Calças": [
      {"nome": "Calça jeans", "icon": "assets/icons/4.1.png"},
      {"nome": "Calça social", "icon": "assets/icons/4.2.png"},
    ],
    "Camisetas": [
      {"nome": "Camiseta social", "icon": "assets/icons/2.2.png"},
      {"nome": "Camiseta comum", "icon": "assets/icons/2.1.png"},
    ],
    "Vestidos": [
      {"nome": "Vestido comum", "icon": "assets/icons/1.1.png"},
      {"nome": "Vestido social", "icon": "assets/icons/1.2.png"},
    ],
    "Tênis": [
      {"nome": "Air Max", "icon": "assets/icons/5.1.png"},
      {"nome": "All-Star", "icon": "assets/icons/5.2.png"},
    ],
    "Bolsas": [
      {"nome": "Bolsa tiracolo", "icon": "assets/icons/6.1.png"},
      {"nome": "Bolsa de mão", "icon": "assets/icons/6.2.png"},
    ],
    "Saltos": [
      {"nome": "Salto alto", "icon": "assets/icons/7.1.png"},
      {"nome": "Salto fino", "icon": "assets/icons/7.2.png"},
    ],
  };

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
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get roupasFiltradas {
    if (categoriaSelecionada.isEmpty) return [];

    final roupas = roupasCategoria[categoriaSelecionada]!;

    if (buscaTexto.isEmpty) return roupas;

    return roupas
        .where(
          (r) => r["nome"].toString().toLowerCase().contains(
            buscaTexto.toLowerCase(),
          ),
        )
        .toList();
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            border: Border.all(color: Colors.white30, width: 1),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Look & Mood",
                              style: GoogleFonts.cinzelDecorative(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 5.5,
                              ),
                            ),
                            Text(
                              "Escolha sua roupa favorita!",
                              style: GoogleFonts.lora(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 33),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white70),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Procurar estilos...",
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            onChanged: (value) {
                              setState(() => buscaTexto = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categorias.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) {
                      final cat = categorias[index]["nome"];
                      final icon = categorias[index]["icon"];
                      final ativo = categoriaSelecionada == cat;
                      final bool isFav = fav.categorias[cat] ?? false;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            categoriaSelecionada = cat;
                            buscaTexto = "";
                            _searchController.clear();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: ativo
                                  ? [roxoPrincipal, roxoEscuro]
                                  : [Colors.white10, Colors.white10],
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                icon,
                                width: 22,
                                height: 22,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cat,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    fav.toggleCategoria(cat);
                                  });
                                },
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav ? Colors.pink : Colors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: roupasFiltradas.isEmpty
                      ? const Center(
                          child: Text(
                            "Nenhum estilo encontrado",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : GridView.count(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          children: roupasFiltradas.map((roupa) {
                            final nome = roupa["nome"];
                            final iconPath = roupa["icon"];
                            final bool isFav =
                                (fav.roupas[nome] ?? false) == true;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OpcaoRoupaView(nomeRoupa: nome),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: LinearGradient(
                                    colors: [
                                      roxoEscuro.withOpacity(0.8),
                                      roxoPrincipal.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            iconPath,
                                            width: 58,
                                            height: 58,
                                            fit: BoxFit.contain,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            nome,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 8,
                                      top: 6,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            fav.toggleRoupa(nome);
                                          });
                                        },
                                                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
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

// WIDGET DE CATEGORIA (mesmo que vc tinha)
class GestureRecognizerWidget extends StatelessWidget {
  final bool ativo;
  final String icon;
  final String cat;
  final Function() onTap;
  final Color roxoPrincipal;
  final Color roxoEscuro;

  const GestureRecognizerWidget({
    super.key,
    required this.ativo,
    required this.icon,
    required this.cat,
    required this.onTap,
    required this.roxoPrincipal,
    required this.roxoEscuro,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: ativo
                ? [roxoPrincipal, roxoEscuro]
                : [Colors.white10, Colors.white10],
          ),
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 22, height: 22, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              cat,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FUNDO ANIMADO (mantive como no teu original)
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
