// ----------------------------------------------------
// -------Base de aplicación y manejo de rutas---------
// ----------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_wl/config.dart';

import 'package:prueba_wl/login.dart';
import 'package:prueba_wl/homepage.dart';
import 'package:prueba_wl/show_albums.dart';
import 'package:prueba_wl/show_artist.dart';
import 'package:prueba_wl/show_categories.dart';
import 'package:prueba_wl/show_new_releases.dart';
import 'package:prueba_wl/show_playlists.dart';
import 'package:prueba_wl/show_search_results.dart';
import 'package:prueba_wl/show_top_tracks.dart';
import 'package:prueba_wl/show_tracks.dart';
import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/provider/user.dart';

Future<void> main() async {
  // Cargar archivo de configuración
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initialize();
  runApp(const MyApp());
}

/// Clase principal
class MyApp extends StatelessWidget {
  ///  Class Key
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Prueba WL';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SpotifyModel(),
        ),
      ],
      child: MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          highlightColor: const Color.fromRGBO(238, 119, 126, 1),
        ),
        initialRoute: '/home',
        routes: <String, WidgetBuilder>{
          '/': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/categories': (context) => const CategoryPage(),
          '/playlists': (context) => const PlaylistPage(),
          '/tracks': (context) => const TrackPage(),
          '/artist': (context) => const ArtistPage(),
          '/albums': (context) => const AlbumPage(),
          '/top-tracks': (context) => const TopTrackPage(),
          '/new-releases': (context) => const NewReleasePage(),
          '/search-results': (context) => const SearchPage(),
        },
      ),
    );
  }
}
