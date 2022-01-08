// ---------------------------------------------------------------------
// ----------------Mostrar detalles de artista--------------------------
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_wl/config.dart';

import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/widgets/app_bar.dart';

/// Clase principal
class ArtistPage extends StatelessWidget {
  const ArtistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ApplicationBar.appBar(context),
        endDrawer: UserInfoCard.drawer(context),
        body: const ArtistPageDetails(),
      );
}

/// Clase de contenido detallado
class ArtistPageDetails extends StatelessWidget {
  const ArtistPageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo de Spotify
    final spotify = context.watch<SpotifyModel>();

    // Revisar integridad de imágenes y géneros
    String _imgLink;
    if (spotify.selectedArtist.images!.isEmpty) {
      _imgLink = Config.defaultAvatar;
    } else {
      _imgLink = spotify.selectedArtist.images!.first;
    }

    return ListView(
      children: [
        // Título
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Información de artista',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Contenido
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.network(
                    _imgLink,
                    errorBuilder: (context, exception, stackTrace) =>
                        Image.asset(
                      Config.defaultAvatar,
                      width: 150,
                      height: 150,
                    ),
                    width: 150,
                    height: 150,
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 150),
                  margin: const EdgeInsets.only(right: 30, left: 10),
                  child: Text(
                    '${spotify.selectedArtist.name}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  margin: const EdgeInsets.only(left: 30),
                  child: const Text(
                    'Seguidores',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                    softWrap: true,
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Text(
                    spotify.selectedArtist.followers.toString(),
                    textAlign: TextAlign.right,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  margin: const EdgeInsets.only(left: 30),
                  child: const Text(
                    'Género',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                    softWrap: true,
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Text(
                    spotify.selectedArtist.genres!.join(', '),
                    textAlign: TextAlign.right,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 200),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    spotify.getAlbums(spotify.selectedArtist.id!);
                    Navigator.pushNamed(context, '/albums');
                  },
                  child: const Text('Ver álbumes'),
                ),
              ),
            ),
            Center(
              child: spotify.selectedCountry.isNotEmpty
                  ? Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          final _countryCode = spotify.selectedCountry
                              .substring(0, 2)
                              .toUpperCase();
                          spotify.getTopTracks(
                              spotify.selectedArtist.id!, _countryCode);
                          Navigator.pushNamed(context, '/top-tracks');
                        },
                        child: const Text('Ver canciones\nmás populares'),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ],
    );
  }
}
