import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:music_app/src/blocs/SpinnerBloc.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/blocs/music_editor.dart';
import 'package:music_app/src/blocs/music_player.dart';
import 'package:music_app/src/blocs/permissions.dart';
import 'package:music_app/src/ui/edit/edit.dart';
import 'package:music_app/src/ui/music_homepage/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MusicCleaner extends StatelessWidget {
  final GlobalBloc _globalBloc;
  final MusicEditorBloc _musicEditorBloc;
  final MusicPlayerBloc _musicPlayerBloc;
  final PermissionsBloc _permissionsBloc;
  final SpinnerBloc _spinnerBloc;

   final Map<String,Widget>_routes = {};
  @provide
  MusicCleaner(this._globalBloc,
      this._spinnerBloc,
      this._musicEditorBloc,
      this._musicPlayerBloc,
      this._permissionsBloc) {
    _routes.addAll( {
      "edit" : BottomAppBar()
    });
  }
  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return FadeRoute(page: Home(_spinnerBloc, _musicPlayerBloc));

      case '/edit':
        this._musicEditorBloc.load((settings.arguments as Map)["track"]);
        return FadeRoute(page: EditTrackScreen(_musicEditorBloc));


      default:
        return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>(
      builder: (BuildContext context) {
        _permissionsBloc.storagePermissionStatus$.listen(
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
            colorScheme: ColorScheme.light(),
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
