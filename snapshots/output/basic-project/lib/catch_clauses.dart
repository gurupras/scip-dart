  // @dart=3.7
// definition scip-dart pub dart_test 1.0.0 lib/`catch_clauses.dart`/
  // Catch-clause parameters are definitions; a wildcard `_` (language 3.7 and
  // later, set above for this library) is not a binding.
  void mayThrow() {}
//     ^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`catch_clauses.dart`/mayThrow().
  
  void catches() {
//     ^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`catch_clauses.dart`/catches().
    try {
      mayThrow();
//    ^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`catch_clauses.dart`/mayThrow().
    } on StateError catch (e, st) {
//       ^^^^^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`errors.dart`/StateError#
//                         ^ definition local 0
//                            ^^ definition local 1
      var x = 1;
//        ^ definition local 2
      print(x);
//    ^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`print.dart`/print().
//          ^ reference local 2
      print(e);
//    ^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`print.dart`/print().
//          ^ reference local 0
      print(st);
//    ^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`print.dart`/print().
//          ^^ reference local 1
    }
    try {
      mayThrow();
//    ^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`catch_clauses.dart`/mayThrow().
    } catch (_) {}
  }
  
