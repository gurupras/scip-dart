  class Range {
// definition scip-dart pub dart_test 1.0.0 lib/`field_formals.dart`/
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`field_formals.dart`/Range#
    final int start;
//        ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//            ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`field_formals.dart`/Range#start.
    final int end;
//        ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//            ^^^ definition scip-dart pub dart_test 1.0.0 lib/`field_formals.dart`/Range#end.
    final int length;
//        ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//            ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`field_formals.dart`/Range#length.
    Range(this.start, this.end)
//  ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`field_formals.dart`/Range#`<constructor>`().
//             ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`field_formals.dart`/Range#start.
//             ^^^^^ definition local 0
//                         ^^^ reference scip-dart pub dart_test 1.0.0 lib/`field_formals.dart`/Range#end.
//                         ^^^ definition local 1
        : assert(start <= end),
//               ^^^^^ reference local 0
//                        ^^^ reference local 1
          length = end - start;
//        ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`field_formals.dart`/Range#length.
//                 ^^^ reference local 1
//                       ^^^^^ reference local 0
  }
  
