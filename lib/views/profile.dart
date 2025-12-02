// lib/views/perfil.dart

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:look_mood/controller/favorites_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilView extends StatefulWidget {
  final String nome;
  final String email;
  final int quantidadeAmigos;

  const PerfilView({
    super.key,
    required this.nome,
    required this.email,
    required this.quantidadeAmigos,
  });

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);

  String abaSelecionada = "Perfil";

  // EDITÁVEIS
  String nome = "";
  String email = "";
  String descricao = "";
  File? fotoPerfil;

  // CONTROLLERS
  final TextEditingController nomeCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  // MODO EDIÇÃO
  bool isEditing = false;

  /// FAVORITOS
  final FavoritesManager fav = FavoritesManager();

  @override
  void initState() {
    super.initState();

    nome = widget.nome;
    email = widget.email;

    _carregarDados();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nome = prefs.getString("perfil_nome") ?? widget.nome;
      email = prefs.getString("perfil_email") ?? widget.email;
      descricao = prefs.getString("perfil_desc") ?? "";

      nomeCtrl.text = nome;
      emailCtrl.text = email;
      descCtrl.text = descricao;

      final fotoPath = prefs.getString("perfil_foto");
      if (fotoPath != null && File(fotoPath).existsSync()) {
        fotoPerfil = File(fotoPath);
      }
    });
  }

  Future<void> _salvarPerfil() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("perfil_nome", nome);
    await prefs.setString("perfil_email", email);
    await prefs.setString("perfil_desc", descricao);

    if (fotoPerfil != null) {
      await prefs.setString("perfil_foto", fotoPerfil!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Perfil salvo com sucesso!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _trocarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      setState(() => fotoPerfil = File(imagem.path));

      // Salvar imediatamente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("perfil_foto", imagem.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriasFavoritas = fav.categorias.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final roupasFavoritas = fav.roupas.entries
        .where((e) => e.value["favorito"] == true)
        .map((e) => e.key)
        .toList();

    final modelosFavoritos = fav.modelos.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
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
                              "Perfil do usuário",
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

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: _trocarFoto,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: roxoPrincipal,
                      backgroundImage: fotoPerfil != null
                          ? FileImage(fotoPerfil!)
                          : null,
                      child: fotoPerfil == null
                          ? const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 45,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAba("Perfil"),
                      _buildAba("Look"),
                      _buildAba("Música"),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(color: Colors.white24, width: 1.2),
                    ),
                    child: _conteudoDaAba(
                      categoriasFavoritas,
                      roupasFavoritas,
                      modelosFavoritos,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Amigos",
                      style: GoogleFonts.lora(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 100,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: roxoPrincipal.withOpacity(0.85),
                    ),
                    child: Center(
                      child: Text(
                        widget.quantidadeAmigos.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAba(String nomeAba) {
    final ativo = abaSelecionada == nomeAba;
    return GestureDetector(
      onTap: () => setState(() => abaSelecionada = nomeAba),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: ativo ? roxoPrincipal : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ativo ? Colors.white : Colors.white24,
            width: 1.3,
          ),
        ),
        child: Text(
          nomeAba,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  Widget _conteudoDaAba(
    List<String> categorias,
    List<String> roupas,
    List<String> modelos,
  ) {
    switch (abaSelecionada) {
      case "Look":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Categorias favoritas",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categorias.isEmpty
                  ? [
                      const Text(
                        "Nenhuma",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ]
                  : categorias.map(_tag).toList(),
            ),
            const SizedBox(height: 18),
            const Text(
              "Roupas favoritas",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: modelos.isEmpty
                  ? [
                      const Text(
                        "Nenhuma",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ]
                  : modelos.map(_tag).toList(),
            ),
          ],
        );
      case "Música":
        final musicasFavoritas = fav.musicas.entries
            .where((e) => e.value["favorito"] == true)
            .map((e) => e.key)
            .toList();

        final categoriasMusicaisFavoritas = fav.categoriasMusicais.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Categorias favoritas",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categoriasMusicaisFavoritas.isEmpty
                  ? [
                      const Text(
                        "Nenhuma",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ]
                  : categoriasMusicaisFavoritas.map(_tag).toList(),
            ),
            const SizedBox(height: 18),
            const Text(
              "Músicas favoritas",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: musicasFavoritas.isEmpty
                  ? [
                      const Text(
                        "Nenhuma",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ]
                  : musicasFavoritas.map(_tag).toList(),
            ),
          ],
        );

      case "Perfil":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nome:", style: TextStyle(color: Colors.white70)),
            TextField(
              controller: nomeCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Digite seu nome"),
              onTap: () => setState(() => isEditing = true),
              onChanged: (v) => nome = v,
            ),

            const SizedBox(height: 20),

            const Text("Email:", style: TextStyle(color: Colors.white70)),
            TextField(
              controller: emailCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Digite seu email"),
              onTap: () => setState(() => isEditing = true),
              onChanged: (v) => email = v,
            ),

            const SizedBox(height: 20),

            const Text("Descrição:", style: TextStyle(color: Colors.white70)),
            TextField(
              controller: descCtrl,
              maxLines: 1,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Digite uma descrição"),
              onTap: () => setState(() => isEditing = true),
              onChanged: (v) => descricao = v,
            ),

            const SizedBox(height: 30),

            if (isEditing)
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
                onPressed: () {
                  _salvarPerfil();
                  setState(() => isEditing = false);
                },
                child: const Text(
                  "Salvar",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
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
