import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:look_mood/views/about_us.dart';
import 'package:look_mood/views/cabinet.dart';
import 'package:look_mood/views/junction.dart';
import 'package:look_mood/views/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:look_mood/views/friends.dart';
import 'package:look_mood/views/musics.dart';
import 'package:look_mood/views/profile.dart';
import 'package:look_mood/controller/favorites_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = -1;
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

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: roxoEscuro,
        title: const Text("Sair da conta", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Tem certeza que deseja sair?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
            },
            child: Text("Sair", style: TextStyle(color: roxoPrincipal)),
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
            builder: (context, _) {
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
                const SizedBox(height: 40),

                // LOGO + LOGOUT ICON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
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
                            "Escolha sua música, e aproveite seu look!",
                            style: GoogleFonts.lora(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white, size: 28),
                          onPressed: _logout,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      padding: const EdgeInsets.all(8),
                      children: [
                        _buildCard(Icons.people, 'Amigos', 0),
                        _buildCard(Icons.checkroom, 'Roupas', 1),
                        _buildCard(Icons.library_music, 'Músicas', 2),
                        _buildCard(Icons.info, 'Sobre Nós', 3),
                        _buildCard(Icons.person, 'Perfil', 4),
                        _buildCard(Icons.join_full, 'Junção', 5),
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

  // ===================== CARD DO MENU ======================
  Widget _buildCard(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);

        // 🚀 switch corrigido — agora funciona corretamente
        switch (index) {
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AmigosView()));
            break;

          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RoupasView()));
            break;

          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MusicasView()));
            break;

          case 3:
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SobreNosView()));
            break;

          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PerfilView(
                  nome: "Seu Nome", 
                  email: "seu@email.com",
                  quantidadeAmigos: 0, 
                ),
              ),
            );
            break;

          case 5:
            Navigator.push(context, MaterialPageRoute(builder: (_) => const JuncaoView()));
            break;
        }
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? roxoPrincipal.withOpacity(0.7)
                  : Colors.black.withOpacity(0.3),
              blurRadius: isSelected ? 20 : 10,
              spreadRadius: isSelected ? 2 : 1,
            ),
          ],
          gradient: LinearGradient(
            colors: isSelected
                ? [roxoPrincipal.withOpacity(0.9), roxoEscuro.withOpacity(0.9)]
                : [roxoEscuro.withOpacity(0.9), Colors.black.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== BACKGROUND ANIMADO =====================
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
          Color.lerp(roxoPrincipal, Colors.deepPurpleAccent, shift * 0.4)!,
        ],
        begin: Alignment(-0.5 + shift * 1.0, -1.0 + shift * 0.8),
        end: Alignment(1.0 - shift * 0.8, 0.8 - shift * 0.5),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }

  @override
  bool shouldRepaint(covariant SmoothMovingBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
