  part 'private_names_part.dart';
// definition scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/
  
  int _helper(int x) => x + 1;
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/_helper().
//            ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                ^ definition local 0
//                      ^ reference local 0
  
  class Holder<T> {
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#
//             ^ definition scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#[T]
    T _value;
//  ^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#[T]
//    ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#_value.
    Holder(this._value);
//  ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#`<constructor>`().
//              ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#_value.
//              ^^^^^^ definition local 1
    Holder._empty(T value) : _value = value;
//         ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#_empty().
//                ^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#[T]
//                  ^^^^^ definition local 2
//                           ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#_value.
//                                    ^^^^^ reference local 2
    T _read() => _value;
//  ^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#[T]
//    ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#_read().
//               ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/Holder#_value.
  }
  
  int usePrivates() => _PartOnly().n + useFromPart();
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_names.dart`/usePrivates().
//                     ^^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_names_part.dart`/_PartOnly#`<constructor>`().
//                                 ^ reference scip-dart pub dart_test 1.0.0 lib/`private_names_part.dart`/_PartOnly#n.
//                                     ^^^^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_names_part.dart`/useFromPart().
  
