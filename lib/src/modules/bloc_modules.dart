
import 'package:inject/inject.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/blocs/music_player.dart';
import 'package:music_app/src/blocs/permissions.dart';

@module
class BlocModule {


  @provide
  @singleton
  MusicPlayerBloc musicPlayerBloc() => MusicPlayerBloc();

  @provide
  @singleton
  GlobalBloc globalBloc(MusicPlayerBloc musicPlayerBloc, PermissionsBloc permissionsBloc) => GlobalBloc(musicPlayerBloc, permissionsBloc);
}