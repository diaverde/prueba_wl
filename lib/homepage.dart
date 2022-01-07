// ---------------------------------------------------------------------
// -------------------------Página principal----------------------------
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/widgets/app_bar.dart';

/// Clase principal
class HomePage extends StatelessWidget {
  ///  Class Key
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => _onBackPressed(context),
        child: Scaffold(
          appBar: ApplicationBar.appBar(context, leavingBlock: true),
          endDrawer: UserInfoCard.drawer(context),
          body: const HomePageDetails(),
        ),
      );

  // Método para confirmar salida de sesión
  Future<bool> _onBackPressed(BuildContext context) async {
    final goBack = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cierre de sesión'),
        content: const Text('¿Cerrar sesión y retornar a la\n'
            'pantalla inicial?'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).highlightColor,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.of(context).popUntil((route) => route.isFirst);
              resetVariables(context);
            },
            child: const Text('Sí'),
          ),
        ],
      ),
    );
    return goBack ?? false;
  }
}

/// Clase para menú
class HomePageDetails extends StatelessWidget {
  const HomePageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Imagen de bienvenida
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Image.asset(
            'images/kenny.png',
            width: 180,
            fit: BoxFit.cover,
            semanticLabel: 'Bienvenida',
          ),
        ),
        // Texto de bienvenida
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Column(
            children: [
              Text('Hola', style: Theme.of(context).textTheme.headline4),
              Text(
                'Bienvenida(o) a mi aplicación\n'
                '¿Qué deseas hacer?',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Conexión a Spotify
        const SpotifyDetails(),
      ],
    );
  }
}

/// Clase para conexión de Spotify
class SpotifyDetails extends StatefulWidget {
  const SpotifyDetails({Key? key}) : super(key: key);

  @override
  _SpotifyDetailsState createState() => _SpotifyDetailsState();
}

class _SpotifyDetailsState extends State<SpotifyDetails> {
  List<String> countries = ['Colombia', 'Australia'];
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Capturar modelo de Spotify
    final spotify = context.watch<SpotifyModel>();

    List<Widget> showCategories() {
      List<Widget> allData = <Widget>[];
      for (final item in spotify.listOfCategories) {
        Widget _singleCategory = Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Text("Id: " + item.id!),
              Text("Nombre: " + item.name!),
            ],
          ),
        );
        allData.add(_singleCategory);
      }
      return allData;
    }

    switch (spotify.sessionStatus) {
      case LoadStatus.idle:
        return Container(
          constraints: const BoxConstraints(maxWidth: 500),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: ElevatedButton(
            onPressed: () async {
              // Conectar
              await spotify.loadSession('');
            },
            child: const Text('Conectar a Spotify'),
          ),
        );
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
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Ver categorías:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
            // Seleccionar país
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Selecciona\nubicación',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCountry,
                      icon:
                          const Icon(Icons.arrow_downward, color: Colors.brown),
                      elevation: 16,
                      style: const TextStyle(fontSize: 14, color: Colors.brown),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCountry = newValue;
                          final _countryCode = newValue!.substring(0, 2);
                          spotify.getCategories(_countryCode);
                        });
                      },
                      items: countries
                          .map<DropdownMenuItem<String>>((value) =>
                              DropdownMenuItem<String>(
                                  value: value, child: Text(value)))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            // Datos
            Center(child: Column(children: showCategories())),
          ],
        );
    }
  }
}
