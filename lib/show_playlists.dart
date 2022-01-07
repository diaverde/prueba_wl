// ---------------------------------------------------------------------
// -------------------------Mostrar playlists---------------------------
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/widgets/app_bar.dart';

/// Clase principal
class PlaylistPage extends StatelessWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ApplicationBar.appBar(context),
        endDrawer: UserInfoCard.drawer(context),
        body: const PlaylistPageDetails(),
      );
}

/// Clase de contenido detallado
class PlaylistPageDetails extends StatelessWidget {
  const PlaylistPageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo de Spotify
    final spotify = context.watch<SpotifyModel>();

    // Obtener lista de playlists
    List<Widget> allData = <Widget>[];
    for (final item in spotify.listOfPlaylists) {
      Widget _singleElement = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            margin: const EdgeInsets.only(left: 30, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
                Text(
                  '${item.description}',
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
                Text(
                  '${item.numberOfTracks} canciones',
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                spotify.selectedPlaylist = item.name!;
                spotify.getTracks(item.id!);
                Navigator.pushNamed(context, '/tracks');
              },
              child: const Text('Ver canciones'),
            ),
          ),
        ],
      );
      allData.add(_singleElement);
    }
    if (allData.isEmpty) {
      allData.add(const Text('No se encontraron listas para esta categoría'));
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
                'Listas de Reproducción',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'País: ${spotify.selectedCountry}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Categoría: ${spotify.selectedCategory}',
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
