  // @dart=3.7
// definition scip-dart pub dart_test 1.0.0 lib/`wildcard_type_parameters.dart`/
  class Pair<_, _> {}
//      ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`wildcard_type_parameters.dart`/Pair#
//           ^ definition local 0
//              ^ definition local 1
  
  void twoWildcards<_, _>() {}
//     ^^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`wildcard_type_parameters.dart`/twoWildcards().
//                  ^ definition local 2
//                     ^ definition local 3
  
  typedef Wild = void Function<_, _>();
//        ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`wildcard_type_parameters.dart`/Wild#
//                             ^ definition local 4
//                                ^ definition local 5
  
