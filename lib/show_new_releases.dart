// ---------------------------------------------------------------------
// ---------------------Mostrar nuevos lanzamientos---------------------
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/widgets/app_bar.dart';

/// Clase principal
class NewReleasePage extends StatelessWidget {
  const NewReleasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ApplicationBar.appBar(context),
        endDrawer: UserInfoCard.drawer(context),
        body: const NewReleasePageDetails(),
      );
}

/// Clase de contenido detallado
class NewReleasePageDetails extends StatelessWidget {
  const NewReleasePageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo de Spotify
    final spotify = context.watch<SpotifyModel>();

    // Obtener lista de elementos
    List<Widget> allData = <Widget>[];
    for (final item in spotify.listOfNewReleases) {
      Widget _singleElement = Container(
        margin: const EdgeInsets.only(left: 30, top: 20),
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
              'Por: ${item.artist!.join(', ')}',
              textAlign: TextAlign.left,
              softWrap: true,
            ),
            Text(
              'Fecha de lanzamiento: ${item.releaseDate}',
              textAlign: TextAlign.left,
              softWrap: true,
            ),
            Text(
              item.totalTracks == 1
                  ? '1 canción'
                  : '${item.totalTracks} canciones',
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ],
        ),
      );
      allData.add(_singleElement);
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
                'Últimos lanzamientos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Estos son los álbumes  más recientes lanzados '
                'en ${spotify.selectedCountry}',
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
