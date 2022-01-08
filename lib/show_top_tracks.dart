// ---------------------------------------------------------------------
// ---------------Mostrar canciones populares de artista----------------
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/widgets/app_bar.dart';

/// Clase principal
class TopTrackPage extends StatelessWidget {
  const TopTrackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ApplicationBar.appBar(context),
        endDrawer: UserInfoCard.drawer(context),
        body: const TopTrackPageDetails(),
      );
}

/// Clase de contenido detallado
class TopTrackPageDetails extends StatelessWidget {
  const TopTrackPageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo de Spotify
    final spotify = context.watch<SpotifyModel>();

    // Obtener lista de canciones
    List<Widget> allData = <Widget>[];
    for (var i = 0; i < spotify.listOfTopTracks.length; i++) {
      Widget _singleElement = Container(
        margin: const EdgeInsets.only(left: 30, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (i + 1).toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Text(
              '${spotify.listOfTopTracks[i].name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
              softWrap: true,
            ),
            Text(
              'Por: ${spotify.listOfTopTracks[i].artist!.join(", ")}',
              textAlign: TextAlign.left,
              softWrap: true,
            ),
            Text(
              'Álbum: ${spotify.listOfTopTracks[i].album}',
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ],
        ),
      );
      allData.add(_singleElement);
    }
    if (allData.isEmpty) {
      allData.add(const Text('No hay canciones para mostrar'));
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
                'Canciones más populares',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Artista: ${spotify.selectedArtist.name}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        // Contenido
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: allData,
        ),
      ],
    );
  }
}
