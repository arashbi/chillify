import 'package:inject/inject.dart';
import 'package:rxdart/rxdart.dart';

class SpinnerBloc {
  Stream<bool> get  spinning => _spinner.stream;

  final _spinner = BehaviorSubject<bool>();
  int _workers = 0;

  @provide
  @singleton
  SpinnerBloc();

  addWorker({String name = ""}) {
    this._workers++;
    if(_workers > 0 ){
      _spinner.add(true);
    }
  }

  done({String name = ""}) {
    this._workers--;
    if(this._workers == 0 ) {
      _spinner.add(false);
    }
  }

}