// Conditional export: use web implementation when compiled for web, otherwise use IO implementation.
export 'connectivity_cubit_io.dart'
    if (dart.library.html) 'connectivity_cubit_web.dart';
