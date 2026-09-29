  part of 'private_names.dart';
// definition scip-dart pub dart_test 1.0.0 lib/`private_names_part.dart`/
  
  class _PartOnly {
//      ^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_names_part.dart`/_PartOnly#
    int n = 0;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^ definition scip-dart pub dart_test 1.0.0 lib/`private_names_part.dart`/_PartOnly#n.
  }
  
  int useFromPart() => _helper(1) + Holder<int>._empty(2)._read();
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_names_part.dart`/useFromPart().
//                     ^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/_helper().
//                                  ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#
//                                         ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                                              ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#_empty().
//                                                        ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#_read().
  
