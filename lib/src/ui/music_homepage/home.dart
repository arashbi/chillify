import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'music_homepage.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return SafeArea(
      child: StreamBuilder<PermissionStatus>(
        stream: _globalBloc.permissionsBloc.storagePermissionStatus$,
        builder: (BuildContext context,
            AsyncSnapshot<PermissionStatus> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final PermissionStatus _status = snapshot.data;
          if (_status == PermissionStatus.denied) {
            _globalBloc.permissionsBloc.requestStoragePermission();
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return MusicHomepage();
          }
        },
      ),
    );
  }


}