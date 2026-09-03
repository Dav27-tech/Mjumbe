import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityCubit extends Cubit<bool> {
  final InternetConnectionChecker? _checker;
  StreamSubscription<InternetConnectionStatus>? _sub;

  ConnectivityCubit([this._checker]) : super(true) {
    if (_checker != null) {
      _sub = _checker!.onStatusChange.listen((status) {
        emit(status == InternetConnectionStatus.connected);
      });
      _checker!.hasConnection.then((value) => emit(value));
    } else {
      // Fallback: assume online
      emit(true);
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
