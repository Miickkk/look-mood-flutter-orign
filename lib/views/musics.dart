import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:look_mood/controller/favorites_manager.dart';
import 'package:look_mood/views/musics_inside.dart';

class MusicasView extends StatefulWidget {
  const MusicasView({super.key});

  @override
  State<MusicasView> createState() => _MusicasViewState();
}

class _MusicasViewState extends State<MusicasView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);

  final TextEditingController _searchController = TextEditingController();
  File? fotoSelecionada;

  final ImagePicker picker = ImagePicker();

  Future<void> selecionarFoto() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        fotoSelecionada = File(img.path);
      });
    }
  }

  List<Map<String, dynamic>> categorias = [
    {"image": "assets/icons/pop.png", "label": "Pop"},
    {"image": "assets/icons/ele.png", "label": "Eletrônica"},
    {"image": "assets/icons/trap.png", "label": "Rap/trap"},
    {"image": "assets/icons/sert.png", "label": "Sertanejo"},
    {"image": "assets/icons/rock.png", "label": "Rock"},
    {"image": "assets/icons/funk.png", "label": "Funk"},
    {"image": "assets/icons/class.png", "label": "Clássica"},
    {"image": "assets/icons/mpb.png", "label": "MPB"},
    {"image": "assets/icons/gospel.png", "label": "Gospel"},
    {"image": "assets/icons/kpopp.png", "label": "K-Pop"},
  ];

  List<Map<String, dynamic>> categoriasFiltradas = [];

  @override
  void initState() {
    super.initState();
    categoriasFiltradas = List.from(categorias);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void filtrarCategorias(String texto) {
    texto = texto.toLowerCase();

    setState(() {
      categoriasFiltradas = categorias
          .where((cat) => cat["label"].toLowerCase().contains(texto))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: SmoothMusicBackground(
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
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              "Encontre seu estilo musical!",
                              style: GoogleFonts.lora(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 33),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildCategoriasFiltradas(),
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

  Widget _buildCategoriasFiltradas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _searchBar(),
        const SizedBox(height: 35),

        Text(
          "Categorias",
          style: GoogleFonts.lora(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        Wrap(
          alignment: WrapAlignment.center,
          spacing: 35,
          runSpacing: 35,
          children: categoriasFiltradas.map((cat) {
            final String? img = cat["image"];
            final String label = cat["label"] ?? "Sem Nome";
            final bool isFavorito =
                FavoritesManager().categoriasMusicais[label] ?? false;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaginaCategoria(nome: label, imagem: img),
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white.withOpacity(0.15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.20),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.20),
                            width: 1.4,
                          ),
                        ),
                        child: img == null
                            ? const Icon(
                                Icons.image_not_supported,
                                color: Colors.white70,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Center(
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                      Color.fromARGB(255, 217, 204, 255),
                                      BlendMode.srcIn,
                                    ),
                                    child: Image.asset(
                                      img,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        top: -6,
                        right: -5,
                        child: IconButton(
                          icon: Icon(
                            isFavorito ? Icons.favorite : Icons.favorite_border,
                            color: isFavorito ? Colors.pinkAccent : Colors.white,
                            size: 23,
                          ),
                          onPressed: () {
                            setState(() {
                              FavoritesManager().toggleCategoriaMusical(label);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    style: GoogleFonts.lora(
                      color: const Color.fromARGB(221, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
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
                  hintText: "Buscar categoria...",
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                onChanged: filtrarCategorias,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------
//  FUNDO
// --------------------------------------------------------------------

class SmoothMusicBackground extends CustomPainter {
  final double animationValue;
  final Color roxoPrincipal;
  final Color roxoEscuro;

  SmoothMusicBackground({
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
          Color.lerp(roxoEscuro, roxoPrincipal, 0.4 + s * 0.2)!,
          Color.lerp(roxoPrincipal, Colors.deepPurpleAccent, 0.3 + s * 0.3)!,
        ],
        begin: Alignment(-1 + s, -1),
        end: Alignment(1 - s, 1),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant SmoothMusicBackground oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
