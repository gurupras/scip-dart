  // Members of unnamed extensions are named under `<extension on T>(k)`, where k
// definition scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/
  // ranks the file's unnamed extensions on the same type.
  extension on List<int> {
// definition local 0
//             ^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`list.dart`/List#
//                  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
    int twice() => 2;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on List<int>>(1)`#twice().
    int get label => 1;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//          ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on List<int>>(1)`#`<get>label`.
  }
  
  extension on Set<int> {
// definition local 1
//             ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`set.dart`/Set#
//                 ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
    int twice() => 3;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on Set<int>>(1)`#twice().
    int get label => 2;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//          ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on Set<int>>(1)`#`<get>label`.
  }
  
  extension on List<int> {
// definition local 2
//             ^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`list.dart`/List#
//                  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
    int thrice() => 3;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on List<int>>(2)`#thrice().
  }
  
  int get label => 0;
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//        ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<get>label`.
  
  int useUnnamedExtensions() =>
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^^^^^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/useUnnamedExtensions().
      [1].twice() + {1}.twice() + [1].label + {1}.label + label + [1].thrice();
//        ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on List<int>>(1)`#twice().
//                      ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on Set<int>>(1)`#twice().
//                                    ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on List<int>>(1)`#`<get>label`.
//                                                ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on Set<int>>(1)`#`<get>label`.
//                                                        ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<get>label`.
//                                                                    ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`unnamed_extensions.dart`/`<extension on List<int>>(2)`#thrice().
  
