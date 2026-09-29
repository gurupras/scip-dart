  int swapped() {
// definition scip-dart pub dart3_features 1.0.0 lib/`assigned_patterns.dart`/
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^^ definition scip-dart pub dart3_features 1.0.0 lib/`assigned_patterns.dart`/swapped().
    var first = 1, second = 2;
//      ^^^^^ definition local 0
//                 ^^^^^^ definition local 1
    (first, second) = (second, first);
//   ^^^^^ reference local 0
//          ^^^^^^ reference local 1
//                     ^^^^^^ reference local 1
//                             ^^^^^ reference local 0
    return first - second;
//         ^^^^^ reference local 0
//                 ^^^^^^ reference local 1
  }
  
