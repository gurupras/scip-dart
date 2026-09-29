  import 'private_overrides.dart';
// definition scip-dart pub dart_test 1.0.0 lib/`private_overrides_other.dart`/
  
  // These do not override PrivateBase's members: a private name is scoped to
  // its library.
  class OtherLibrary extends PrivateBase {
//      ^^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides_other.dart`/OtherLibrary#
//      relationship scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase# implementation
//                           ^^^^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase#
    int _tick() => 2;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides_other.dart`/OtherLibrary#_tick().
//      diagnostic Warning:
//      > The declaration '_tick' isn't referenced.
    int _count = 0;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides_other.dart`/OtherLibrary#_count.
    int get _label => _count;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//          ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides_other.dart`/OtherLibrary#`<get>_label`.
//          diagnostic Warning:
//          > The declaration '_label' isn't referenced.
//                    ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_overrides_other.dart`/OtherLibrary#_count.
  }
  
