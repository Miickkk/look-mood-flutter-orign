import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:look_mood/controller/favorites_manager.dart';
import 'package:look_mood/views/lyrics.dart';
import 'package:look_mood/views/lyrics.dart';

class PaginaCategoria extends StatefulWidget {
  final String nome;
  final String? imagem;

  const PaginaCategoria({super.key, required this.nome, this.imagem});

  @override
  State<PaginaCategoria> createState() => _PaginaCategoriaState();
}

class _PaginaCategoriaState extends State<PaginaCategoria>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Color roxoPrincipal = const Color(0xFF6137DE);
  final Color roxoEscuro = const Color(0xFF241536);

  final Map<String, List<Map<String, String>>> musicasPorCategoria = {
    "Pop": [
      {
        "titulo": "Die For You",
        "artista": "The Weeknd",
        "letra": """
I'm findin' ways to articulate the feeling I'm goin' through
I just can't say I don't love you
'Cause I love you, yeah
It's hard for me to communicate the thoughts that I hold
But tonight I'm gon' let you know
Let me tell the truth
Baby, let me tell the truth, yeah

You know what I'm thinkin', see it in your eyes
You hate that you want me, hate it when you cry
You're scared to be lonely, 'specially in the night
I'm scared that I'll miss you, happens every time
I don't want this feelin', I can't afford love
I try to find a reason to pull us apart
It ain't workin' 'cause you're perfect
And I know that you're worth it
I can't walk away, oh!

Even though we're going through it
And it makes you feel alone
Just know that I would die for you
Baby, I would die for you, yeah
The distance and the time between us
It'll never change my mind, 'cause baby
I would die for you
Baby, I would die for you, yeah

I'm finding ways to manipulate the feelin' you're goin' through
But baby girl, I'm not blamin' you
Just don't blame me, too, yeah
'Cause I can't take this pain forever
And you won't find no one that's better
'Cause I'm right for you, babe
I think I'm right for you, babe

You know what I'm thinkin', see it in your eyes
You hate that you want me, hate it when you cry
It ain't workin' 'cause you're perfect
And I know that you're worth it
I can't walk away, oh!

Even though we're going through it
And it makes you feel alone
Just know that I would die for you
Baby, I would die for you, yeah
The distance and the time between us
It'll never change my mind, 'cause baby
I would die for you
Baby, I would die for you, yeah

I would die for you, I would lie for you
Keep it real with you, I would kill for you, my baby
I'm just sayin', yeah
I would die for you, I would lie for you
Keep it real with you, I would kill for you, my baby
Na-na-na, na-na-na, na-na-na

Even though we're going through it
And it makes you feel alone
Just know that I would die for you
Baby, I would die for you, yeah
The distance and the time between us
It'll never change my mind, 'cause baby
I would die for you
Baby, I would die for you, yeah babe
(Die for you)""",
      },
      {
        "titulo": "Style",
        "artista": "Taylor Swift",
        "letra": """
Midnight
You come and pick me up, no headlights
A long drive
Could end in burning flames or paradise

Fade into view, oh
It's been a while since I have even heard from you
(Heard from you)

And I should just tell you to leave, 'cause I
Know exactly where it leads, but I
Watch us go 'round and 'round each time

You got that James Dean daydream look in your eye
And I got that red lip, classic thing that you like
And when we go crashing down, we come back every time
'Cause we never go out of style
We never go out of style

You got that long hair, slicked back, white t-shirt
And I got that good girl faith and a tight little skirt
And when we go crashing down, we come back every time
'Cause we never go out of style
We never go out of style

So it goes
He can't keep his wild eyes on the road
Takes me home
The lights are off, he's taking off his coat

I say: I heard, oh
That you've been out and about with some other girl
(Some other girl)

He says: What you heard is true, but I
Can't stop thinking about you, and I
I said: I've been there too, a few times

'Cause you got that James Dean daydream look in your eye
And I got that red lip, classic thing that you like
And when we go crashing down, we come back every time
'Cause we never go out of style
We never go out of style

You got that long hair, slicked back, white t-shirt
And I got that good girl faith and a tight little skirt (a tight little skirt)
And when we go crashing down, we come back every time
'Cause we never go out of style (we never go, we never go)
We never go out of style

Take me home
Just take me home
Yeah, just take me home
Oh, oh, oh
(Out of style)

You got that James Dean daydream look in your eye
And I got that red lip, classic thing that you like
And when we go crashing down, we come back every time (and when we go)
'Cause we never go out of style
We never go out of style""",
      },
    ],

    "Eletrônica": [
      {
        "titulo": "The Nights",
        "artista": "Avicii",
        "letra": "Letra completa da música aqui...",
      },
      {
        "titulo": "Animals",
        "artista": "Martin Garrix",
        "letra": "Letra completa da música aqui...",
      },
    ],

    "Rap/trap": [
      {"titulo": "M4", "artista": "Teto", "letra": "Letra da música M4..."},
      {
        "titulo": "Plaqtudum",
        "artista": "Veigh",
        "letra": "Letra completa desta música...",
      },
    ],

    "Sertanejo": [
      {
        "titulo": "Evidências",
        "artista": "Chitãozinho & Xororó",
        "letra": "Letra completa aqui...",
      },
      {
        "titulo": "Amei Te Ver",
        "artista": "Tiago Iorc",
        "letra": "Letra completa aqui...",
      },
    ],

    "Rock": [
      {
        "titulo": "Smells Like Teen Spirit",
        "artista": "Nirvana",
        "letra": "Letra completa aqui...",
      },
      {
        "titulo": "Bohemian Rhapsody",
        "artista": "Queen",
        "letra": "Letra completa aqui...",
      },
    ],

    "Funk": [
      {
        "titulo": "Modo Malvadão",
        "artista": "Xamã",
        "letra": "Letra completa aqui...",
      },
      {
        "titulo": "Sentadão",
        "artista": "Pedro Sampaio",
        "letra": "Letra completa aqui...",
      },
    ],

    "Clássica": [
      {
        "titulo": "Clair de Lune",
        "artista": "Claude Debussy",
        "letra": "Música instrumental...",
      },
      {
        "titulo": "Nocturne Op. 9 No. 2",
        "artista": "Frédéric Chopin",
        "letra": "Música instrumental...",
      },
    ],

    "MPB": [
      {
        "titulo": "Aquarela",
        "artista": "Toquinho",
        "letra": "Letra completa aqui...",
      },
      {
        "titulo": "Oceano",
        "artista": "Djavan",
        "letra": "Letra completa aqui...",
      },
    ],

    "Gospel": [
      {
        "titulo": "Via Dolorosa",
        "artista": "Aline Barros",
        "letra": "Letra completa aqui...",
      },
      {
        "titulo": "Ousado Amor",
        "artista": "Isaias Saad",
        "letra": "Letra completa aqui...",
      },
    ],

    "K-Pop": [
      {"titulo": "Butter", "artista": "BTS", "letra": "Letra completa aqui..."},
      {
        "titulo": "Kill This Love",
        "artista": "BLACKPINK",
        "letra": "Letra completa aqui...",
      },
    ],
  };

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
    final listaMusicas = musicasPorCategoria[widget.nome] ?? [];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                painter: SmoothGradientBackground(
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
                              widget.nome,
                              style: GoogleFonts.cinzelDecorative(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Músicas e letras",
                              style: GoogleFonts.lora(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 45),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: listaMusicas.length,
                      itemBuilder: (_, i) {
                        final m = listaMusicas[i];
                        final String titulo = m["titulo"]!;
                        final String artista = m["artista"]!;

                        // Pegando o estado atual do favorito do FavoritesManager
                        final bool isFavorito =
                            FavoritesManager().musicas[titulo]?["favorito"] ??
                            false;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LetraMusicaView(
                                  titulo: titulo,
                                  artista: artista,
                                  letra: m["letra"]!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 18),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.22),
                                width: 1.3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.18),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        titulo,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        artista,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorito
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorito
                                        ? Colors.pinkAccent
                                        : Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      FavoritesManager().toggleMusica(titulo);
                                    });
                                  },
                                ),
                              ],
                            ),
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

// FUNDO IGUAL AO DAS MÚSICAS
class SmoothGradientBackground extends CustomPainter {
  final double animationValue;
  final Color roxoPrincipal;
  final Color roxoEscuro;

  SmoothGradientBackground({
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
  bool shouldRepaint(covariant SmoothGradientBackground oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
