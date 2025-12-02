// lib/views/juncao.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:look_mood/controller/favorites_manager.dart';
import 'package:dart_openai/dart_openai.dart';

class JuncaoView extends StatefulWidget {
  const JuncaoView({super.key});

  @override
  State<JuncaoView> createState() => _JuncaoViewState();
}

class _JuncaoViewState extends State<JuncaoView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);

  final FavoritesManager fav = FavoritesManager();

  Map<String, String> lookGerado = {};
  String? imageUrl;

  String selectedRoupas = "Casual";
  String selectedMusica = "Pop";

  final List<String> categoriasRoupas = [
    "Casual",
    "Esportivo",
    "Formal",
    "Streetwear",
    "Luxo"
  ];
  final List<String> estilosMusicais = [
    "Pop",
    "Rock",
    "Eletrônica",
    "Jazz",
    "Hip-Hop"
  ];

  @override
  void initState() {
    super.initState();
    OpenAI.apiKey = "COLE_AQUI_SUA_API_KEY_OPENAI";
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _gerarLook();
  }

  Future<void> _gerarLook() async {
    setState(() {
      lookGerado = {};
      imageUrl = null;
    });

    final prompt = """
Crie um look baseado nas preferências do usuário.
Categoria de roupa: $selectedRoupas
Estilo musical: $selectedMusica

Retorne um JSON com:
{
  "roupa": "nome da roupa sugerida",
  "musica": "nome da música sugerida"
}

Depois gere uma imagem desse look.
""";

    try {
      // Gerar o texto do look
      final chatResponse = await OpenAI.instance.chat.completions.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatMessageModel(
            role: OpenAIChatMessageRole.user,
            content: prompt,
          ),
        ],
      );

      final String text = chatResponse.choices.first.message.content;
      final Map<String, dynamic> jsonResp = jsonDecode(text);

      setState(() {
        lookGerado = {
          "roupa": jsonResp["roupa"] ?? "Roupa sugerida",
          "musica": jsonResp["musica"] ?? "Música sugerida",
        };
      });

      // Gerar imagem
      final imageResponse = await OpenAI.instance.images.generateImage(
        model: "gpt-image-1",
        prompt:
            "Imagem realista de um look: ${lookGerado['roupa']}, estilo ${selectedRoupas}",
        size: "512x512",
      );

      setState(() {
        imageUrl = imageResponse.data.first.url;
      });
    } catch (e) {
      print("Erro ao gerar look AI: $e");
      setState(() {
        lookGerado = {
          "roupa": "Erro ao gerar look",
          "musica": "Erro ao gerar look"
        };
        imageUrl = null;
      });
    }
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
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
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              "Escolha categoria e estilo musical",
                              style: GoogleFonts.lora(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Dropdown para categoria de roupas
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedRoupas,
                          dropdownColor: roxoEscuro,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Categoria de roupa",
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: roxoEscuro.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: categoriasRoupas
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedRoupas = v!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedMusica,
                          dropdownColor: roxoEscuro,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Estilo musical",
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: roxoEscuro.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: estilosMusicais
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedMusica = v!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: lookGerado.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (imageUrl != null)
                                Container(
                                  width: 250,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                        image: NetworkImage(imageUrl!),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              _cardLook("Roupa", lookGerado["roupa"]!),
                              const SizedBox(height: 20),
                              _cardLook("Música", lookGerado["musica"]!),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: roxoPrincipal,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 25,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: _gerarLook,
                                child: const Text(
                                  "Gerar novo look",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardLook(String tipo, String nome) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [roxoEscuro.withOpacity(0.8), roxoPrincipal.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            tipo,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            nome,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// FUNDO ANIMADO
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
