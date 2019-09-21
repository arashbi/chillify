import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/music_editor.dart';
import 'package:music_app/src/ui/now_playing/empty_album_art.dart';

class EditTrackScreen extends StatelessWidget {
  final MusicEditorBloc _musicEditorBloc;
  EditTrackScreen(this._musicEditorBloc);
  TextEditingController _titleController = TextEditingController();
  TextEditingController _artistController = TextEditingController();
  TextEditingController _genreController = TextEditingController();
  TextEditingController _albumController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double _radius = 25.0;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _albumArtSize = _screenHeight / 3;
    return Scaffold(
        body: StreamBuilder<TrackModel>(
            stream: _musicEditorBloc.trackModel$,
            builder:
                (BuildContext context, AsyncSnapshot<TrackModel> snapshot) {
              if (!snapshot.hasData) {
                return EmptyAlbumArtContainer(
                  radius: _radius,
                  albumArtSize: _albumArtSize,
                  iconSize: _albumArtSize / 2,
                );
              }

              final model = snapshot.data;
              return Form(
                child: CustomScrollView(

                    slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 250.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(model.title),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        FieldInput(label: "Title", value: model.title,
                          controller: _titleController,),
                        FieldInput(
                          label: "Artist",
                          value: model.artist,
                          controller: _artistController,
                        ),
                        FieldInput(
                            label: "Album",
                            controller:  _albumController,
                            value: model.album),
                        FieldInput(
                          label: "Genre",
                          value: model.genre,
                          controller: _genreController,
                        ),
                        ButtonBar(
                          children: <Widget>[
                            RaisedButton(
                              child: Text("Save"),
                              onPressed: () {
                                model.album = _albumController.text;
                                model.title = _titleController.text;
                                model.genre = _genreController.text;
                                model.artist = _artistController.text;
                                _musicEditorBloc.save(model);
                                Navigator.of(context).pop();

                              },
                            ),
                            RaisedButton(
                              child: Text("Cancel"),
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme
                                  .background,
                              onPressed: () =>Navigator.of(context).pop()
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ]),
              );
            }));
  }

  String getDuration(Song _song) {
    final double _temp = _song.duration / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      return _minutes.toString() + ":" + _seconds.toString();
    } else {
      return _minutes.toString() + ":0" + _seconds.toString();
    }
  }
}

class FieldInput extends StatelessWidget {
  const FieldInput({Key key, @required this.label, @required this.value, this.controller})
      : super(key: key);
  final String label;
  final String value;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    controller.text = value;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderSide: BorderSide())),

      ),
    );
  }
}

class EditHeader extends StatelessWidget {
  TrackModel _model;

  EditHeader(this._model);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 4;
    return Container(
        width: double.infinity,
        height: height,
        color: Colors.blue,
        padding: EdgeInsets.only(bottom: 10),
        child: Center(
          child: Text(
            _model.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            textScaleFactor: 3,
          ),
        ));
  }
}
