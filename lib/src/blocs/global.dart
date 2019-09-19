import 'package:music_app/src/blocs/music_editor.dart';
import 'package:music_app/src/blocs/music_player.dart';
import 'package:music_app/src/blocs/permissions.dart';

class GlobalBloc {
  PermissionsBloc _permissionsBloc;
  MusicPlayerBloc _musicPlayerBloc;
  MusicEditorBloc _musicEditorBloc;

  MusicPlayerBloc get musicPlayerBloc => _musicPlayerBloc;
  PermissionsBloc get permissionsBloc => _permissionsBloc;
  MusicEditorBloc get musicEditorBloc => _musicEditorBloc;

  GlobalBloc() {
    _musicPlayerBloc = MusicPlayerBloc();
    _musicEditorBloc = MusicEditorBloc();
    _permissionsBloc = PermissionsBloc();
  }

  void dispose() {
    _musicPlayerBloc.dispose();
    _permissionsBloc.dispose();
  }
}
