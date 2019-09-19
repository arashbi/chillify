import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/ui/edit/edit.dart';
import 'package:music_app/src/ui/music_homepage/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ChillifyApp extends StatelessWidget {
  final GlobalBloc _globalBloc = GlobalBloc();
   Map<String,Widget>_routes;
  ChillifyApp() {
    _routes = {
      "edit" : BottomAppBar()
    };
  }
  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return FadeRoute(page: Home());

      case '/edit':
        this._globalBloc.musicEditorBloc.load((settings.arguments as Map)["track"]);
        return FadeRoute(page: EditTrackScreen());


      default:
        return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>(
      builder: (BuildContext context) {
        _globalBloc.permissionsBloc.storagePermissionStatus$.listen(
          (data) {
            if (data == PermissionStatus.granted) {
              _globalBloc.musicPlayerBloc.fetchSongs().then(
                (_) {
                  _globalBloc.musicPlayerBloc.retrieveFavorites();
                },
              );
            }
          },
        );
        return _globalBloc;
      },
      dispose: (BuildContext context, GlobalBloc value) => value.dispose(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          sliderTheme: SliderThemeData(
            trackHeight: 1,
          ),
          buttonTheme: ButtonThemeData(
            colorScheme: ColorScheme.dark(),
          )
        ),

        onGenerateRoute: _getRoute),
    );
  }
}


class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
