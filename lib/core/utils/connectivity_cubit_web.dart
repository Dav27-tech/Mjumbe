import 'dart:async';
import 'dart:html' as html;
import 'package:bloc/bloc.dart';

class ConnectivityCubit extends Cubit<bool> {
  StreamSubscription<html.Event>? _onlineSub;
  StreamSubscription<html.Event>? _offlineSub;

  ConnectivityCubit([_]) : super(html.window.navigator.onLine ?? true) {
    _onlineSub = html.window.onOnline.listen((_) => emit(true));
    _offlineSub = html.window.onOffline.listen((_) => emit(false));
  }

  @override
  Future<void> close() async {
    await _onlineSub?.cancel();
    await _offlineSub?.cancel();
    return super.close();
  }
}
