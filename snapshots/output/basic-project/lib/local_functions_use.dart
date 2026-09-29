  import 'local_functions.dart';
// definition scip-dart pub dart_test 1.0.0 lib/`local_functions_use.dart`/
  
  int useEscaped() => escaped(body: 1);
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions_use.dart`/useEscaped().
//                    ^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/escaped.
//                            ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/escaped.`<anonymous>`(1).h(1).(body)
  
