class FavoritesManager {
  // ------------ SINGLETON ------------
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();
  // -----------------------------------

  Map<String, bool> categorias = {};
  Map<String, Map<String, dynamic>> roupas = {};
  Map<String, bool> modelos = {};

  // NOVOS
  Map<String, bool> categoriasMusicais = {};
  Map<String, Map<String, dynamic>> musicas = {}; // {"titulo": {"favorito": true, "categoria": "Pop"}}

  // ------------ CATEGORIAS ------------
  void toggleCategoria(String nome) {
    categorias[nome] = !(categorias[nome] ?? false);
  }

  void toggleCategoriaMusical(String nome) {
    categoriasMusicais[nome] = !(categoriasMusicais[nome] ?? false);
  }

  // ------------ ROUPAS ------------
  void toggleRoupa(String nome) {
    if (!roupas.containsKey(nome)) {
      roupas[nome] = {"favorito": true};
    } else {
      roupas[nome]!["favorito"] = !(roupas[nome]!["favorito"] ?? false);
    }
  }

  // ------------ MODELOS ------------
  void toggleModelo(String nome) {
    modelos[nome] = !(modelos[nome] ?? false);
  }

  // ------------ MÚSICAS ------------
  void toggleMusica(String titulo) {
    if (!musicas.containsKey(titulo)) {
      musicas[titulo] = {"favorito": true, "categoria": ""};
    } else {
      musicas[titulo]!["favorito"] = !(musicas[titulo]!["favorito"] ?? false);
    }
  }
}
