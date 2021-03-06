// ---------------------------------------------------------------------
// -------------------------Mostrar canciones---------------------------
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/widgets/app_bar.dart';

/// Clase principal
class TrackPage extends StatelessWidget {
  const TrackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ApplicationBar.appBar(context),
        endDrawer: UserInfoCard.drawer(context),
        body: const TrackPageDetails(),
      );
}

/// Clase de contenido detallado
class TrackPageDetails extends StatelessWidget {
  const TrackPageDetails({Key? key}) : super(key: key);

  // Método para seleccionar artista para ver detalles (si hay varios)
  void _selectArtist(
      BuildContext context, List<String> artists, List<String> artistIDs) {
    int _selectedValue = 0;
    showDialog<void>(
      context: context,
      builder: (context) {
        // Capturar modelo de Spotify
        final spotify = context.watch<SpotifyModel>();
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Seleccione artista para ver detalles',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  children: List<Widget>.generate(
                    artists.length,
                    (int i) => ListTile(
                      dense: true,
                      title: Text(artists[i]),
                      leading: Radio(
                        value: i,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          final _newArtist = artists[value as int];
                          _selectedValue = artists.indexOf(_newArtist);
                          spotify.setNewArtistName(_newArtist);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                spotify.getArtist(artistIDs[_selectedValue]);
                Navigator.pushNamed(context, '/artist');
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Capturar modelo de Spotify
    final spotify = context.watch<SpotifyModel>();

    // Obtener lista de canciones
    List<Widget> allData = <Widget>[];
    for (var i = 0; i < spotify.listOfTracks.length; i++) {
      // Extraer artistas si hay varios
      String _artists = spotify.listOfTracks[i].artist!.join(", ");
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
                  (i + 1).toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '${spotify.listOfTracks[i].name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
                Text(
                  'Álbum: ${spotify.listOfTracks[i].album}',
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 150),
            margin: const EdgeInsets.only(right: 30, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Artista: $_artists',
                  softWrap: true,
                  textAlign: TextAlign.end,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (spotify.listOfTracks[i].artistID!.length > 1) {
                      _selectArtist(context, spotify.listOfTracks[i].artist!,
                          spotify.listOfTracks[i].artistID!);
                    } else {
                      spotify.getArtist(spotify.listOfTracks[i].artistID![0]);
                      Navigator.pushNamed(context, '/artist');
                    }
                  },
                  child: const Text('Ver detalles'),
                ),
              ],
            ),
          ),
        ],
      );
      allData.add(_singleElement);
    }
    if (allData.isEmpty) {
      allData.add(const Text('Lista de reproducción vacía'));
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
                'Pistas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Lista de reproducción: ${spotify.selectedPlaylist}',
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
