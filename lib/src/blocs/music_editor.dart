
import 'dart:core';
import 'dart:ffi';
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:inject/inject.dart';
import 'package:music_app/src/blocs/SpinnerBloc.dart';
import 'package:rxdart/rxdart.dart';

import 'music_player.dart';

class MusicEditorBloc {
  BehaviorSubject<TrackModel> _trackModel$ = BehaviorSubject();

  final SpinnerBloc _spinnerBloc;

  final MusicPlayerBloc _musicPlayerBloc;

  BehaviorSubject<TrackModel> get trackModel$ => _trackModel$;

  @provide
  @singleton
  MusicEditorBloc(this._spinnerBloc, this._musicPlayerBloc);

  void save(TrackModel model) {
    _spinnerBloc.addWorker();
    print("Saving track model");
    _saveModel(model)
        .then((void v) => this._musicPlayerBloc.fetchSongs()).then(_spinnerBloc.done());
  }

  void load(String track){
    trackModel$.add(TrackModel());
    Future<TrackModel> model = _loadModel(track);
    model.then( (m) {
      m.uri = track;
      _trackModel$.add(m);
    });


  }
   Future<TrackModel> _loadModel(String track) async {
    var file =  File(track);
    TagProcessor tp = TagProcessor();
     var m  = tp.getTagsFromByteArray(file.readAsBytes(),[TagType.id3v2]).then((tags) {
      TrackModel model = TrackModel(
          title: tags[0].tags['title'],
          artist: tags[0].tags['artist'],
          genre: tags[0].tags['genre'],
          album: tags[0].tags['album']
      );
      return model;
    });
     return m;
  }

  Future<Void>_saveModel(TrackModel model) {
    var file = File(model.uri);

    TagProcessor tp = TagProcessor();
    var bytes = file.readAsBytes();
    return tp.getTagsFromByteArray(bytes,[TagType.id3v2]).then((tags) {
      tags[0].tags = model.asMap();
      return tags;
    }).then((tag) {
      return tp.putTagsToByteArray(file.readAsBytes(),tag);
    }).then((bytes){
      return File(model.uri).writeAsBytes(bytes);
    }).then((File file){
      print('file written');
      print(file.path);
      return;
    });
  }
}

class TrackModel {
  String title;
  String artist;
  String genre;
  String album;
  String uri;
  TrackModel({this.title, this.artist, this.genre, this.album, this.uri});

  @override
  String toString() {
    return "Track: $title, $artist, $album, $genre";
  }

  Map<String, String> asMap() {
    return {
      "title" : title,
      "artist" : artist,
      "genre" : genre,
      "album" : album
    };
  }
}