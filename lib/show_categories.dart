// ---------------------------------------------------------------------
// -------------------------Mostrar categorías--------------------------
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/widgets/app_bar.dart';

/// Clase principal
class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ApplicationBar.appBar(context),
        endDrawer: UserInfoCard.drawer(context),
        body: const CategoryPageDetails(),
      );
}

/// Clase de contenido detallado
class CategoryPageDetails extends StatelessWidget {
  const CategoryPageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo de Spotify
    final spotify = context.watch<SpotifyModel>();

    // Obtener lista de categorías
    List<Widget> allData = <Widget>[];
    for (final item in spotify.listOfCategories) {
      Widget _singleCategory = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            margin: const EdgeInsets.only(left: 30),
            child: Text(
              '${item.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            child: ElevatedButton(
              onPressed: () {
                spotify.selectedCategory = item.name!;
                final _countryCode =
                    spotify.selectedCountry.substring(0, 2).toUpperCase();
                spotify.getPlaylists(_countryCode, item.id!);
                Navigator.pushNamed(context, '/playlists');
              },
              child: const Text('Ver playlists'),
            ),
          ),
        ],
      );
      allData.add(_singleCategory);
    }

    return ListView(
      children: [
        // Título
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categorías',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Estas son las categorías más populares en ${spotify.selectedCountry}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        // Contenido
        Column(
          children: allData,
        ),
      ],
    );
  }
}
