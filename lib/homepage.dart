// ---------------------------------------------------------------------
// -------------------------Página principal----------------------------
// ---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              LogoutFunctions.logoutFB();
              LogoutFunctions.resetVariables(context);
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
  // "Text controller" para búsqueda
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Capturar modelo de Spotify
    final spotify = context.watch<SpotifyModel>();

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
            // Seleccionar país
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      value: spotify.selectedCountry.isEmpty
                          ? null
                          : spotify.selectedCountry,
                      icon:
                          const Icon(Icons.arrow_downward, color: Colors.brown),
                      elevation: 16,
                      style: const TextStyle(fontSize: 14, color: Colors.brown),
                      onChanged: (newValue) {
                        setState(() {
                          spotify.selectedCountry = newValue!;
                        });
                      },
                      items: spotify.countries
                          .map<DropdownMenuItem<String>>((value) =>
                              DropdownMenuItem<String>(
                                  value: value, child: Text(value)))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            // Ver categorías
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Categorías más populares',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: spotify.selectedCountry.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor,
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        if (spotify.selectedCountry.isNotEmpty) {
                          final _countryCode = spotify.selectedCountry
                              .substring(0, 2)
                              .toUpperCase();
                          spotify.getCategories(_countryCode);
                          Navigator.pushNamed(context, '/categories');
                        } else {
                          showSnackbar(
                            'Seleccione un país para habilitar esta opción',
                            context,
                          );
                        }
                      },
                      child: const Text('Mostrar'),
                    ),
                  ),
                ],
              ),
            ),
            // Ver últimos lanzamientos
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Últimos lanzamientos',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: spotify.selectedCountry.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor,
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        if (spotify.selectedCountry.isNotEmpty) {
                          final _countryCode = spotify.selectedCountry
                              .substring(0, 2)
                              .toUpperCase();
                          spotify.getNewReleases(_countryCode);
                          Navigator.pushNamed(context, '/new-releases');
                        } else {
                          showSnackbar(
                            'Seleccione un país para habilitar esta opción',
                            context,
                          );
                        }
                      },
                      child: const Text('Mostrar'),
                    ),
                  ),
                ],
              ),
            ),
            // Búsqueda
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Buscar en Spotify',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Buscar por:'),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: spotify.selectedSearchType.isEmpty
                                ? null
                                : spotify.selectedSearchType,
                            icon: const Icon(Icons.arrow_downward,
                                color: Colors.brown),
                            elevation: 16,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.brown),
                            onChanged: (newValue) {
                              setState(() {
                                spotify.selectedSearchType = newValue!;
                              });
                            },
                            items: spotify.searchTypes.keys
                                .map<DropdownMenuItem<String>>((value) =>
                                    DropdownMenuItem<String>(
                                        value: value, child: Text(value)))
                                .toList(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              hintText: 'Ingrese texto de búsqueda',
                              hintStyle: const TextStyle(fontSize: 12),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp('[\n\t\r]'))
                            ],
                            maxLength: 30,
                            controller: myController,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (myController.text.isNotEmpty &&
                                  spotify.selectedSearchType.isNotEmpty) {
                                spotify.searchStatus = LoadStatus.idle;
                                spotify.searchText = myController.text;
                                spotify.loadSearchResults(
                                    spotify.searchTypes[
                                        spotify.selectedSearchType]!,
                                    spotify.searchText);
                                Navigator.pushNamed(context, '/search-results');
                              } else {
                                showSnackbar(
                                  'Ingrese texto para buscar y filtro adecuado',
                                  context,
                                );
                              }
                            },
                            child: const Text('Buscar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  /// Método para mostrar mensajes al usuario como snackBar
  void showSnackbar(String toShow, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(toShow)));
  }
}
