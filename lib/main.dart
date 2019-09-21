import 'package:flutter/material.dart';
import 'package:music_app/src/injectors/bloc_injector.dart';
import 'package:music_app/src/modules/bloc_modules.dart';

void main() async {
  var container = await BlocInjector.create(BlocModule());
  runApp(container.app);
}
