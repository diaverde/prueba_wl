// ---------------------------------------------------------------------
// -----------------Mostrar resultados de búsqueda----------------------
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/widgets/app_bar.dart';

/// Clase principal
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ApplicationBar.appBar(context),
        endDrawer: UserInfoCard.drawer(context),
        body: const SearchPageDetails(),
      );
}

/// Clase de contenido detallado
class SearchPageDetails extends StatelessWidget {
  const SearchPageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo de Spotify
    final spotify = context.watch<SpotifyModel>();

    switch (spotify.searchStatus) {
      case LoadStatus.idle:
        return Container();
      case LoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Error de conexión\n',
                textAlign: TextAlign.center,
              ),
              Text(
                'Intente de nuevo más tarde o \n'
                'contacte al administrador del sitio.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      case LoadStatus.loaded:
        // Obtener lista de elementos
        List<Widget> allData = <Widget>[];
        for (final item in spotify.listOfSearchResults) {
          Widget _singleElement;
          switch (spotify.selectedSearchType) {
            case 'Álbum':
              _singleElement = Container(
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
              break;
            case 'Artista':
              _singleElement = Container(
                margin: const EdgeInsets.only(left: 30, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200),
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
                            'Seguidores: ${item.followers.toString()}',
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                          Text(
                            'Género: ${item.genres!.join(', ')}',
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      margin: const EdgeInsets.only(right: 30, top: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          spotify.getArtist(item.id);
                          Navigator.pushNamed(context, '/artist');
                        },
                        child: const Text('Ver detalles'),
                      ),
                    ),
                  ],
                ),
              );
              break;
            case 'Playlist':
              _singleElement = Container(
                margin: const EdgeInsets.only(left: 30, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200),
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
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
                ),
              );
              break;
            case 'Canción':
              _singleElement = Container(
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
                      'Álbum: ${item.album}',
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                    Text(
                      'Artista: ${item.artist!.join(", ")}',
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ],
                ),
              );
              break;
            default:
              _singleElement = Container();
          }
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
                    'Búsqueda',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Estos son los resultados de la búsqueda',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${spotify.selectedSearchType} ---> "${spotify.searchText}"',
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
            // Botón de regreso
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Volver'),
              ),
            ),
          ],
        );
    }
  }
}
