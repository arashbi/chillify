
import 'package:inject/inject.dart';
import 'package:music_app/src/modules/bloc_modules.dart';
import 'bloc_injector.inject.dart' as g;
import '../root.dart';


@Injector(const [BlocModule])
abstract class BlocInjector{
  @provide
  MusicCleaner get app;

  static final create = g.BlocInjector$Injector.create;
}