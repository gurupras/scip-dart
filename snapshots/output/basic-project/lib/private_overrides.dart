  class PrivateBase {
// definition scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/
//      ^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase#
    int _tick() => 0;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase#_tick().
//      diagnostic Warning:
//      > The declaration '_tick' isn't referenced.
    int _count = 0;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase#_count.
    int get _label => _count;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//          ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase#`<get>_label`.
//          diagnostic Warning:
//          > The declaration '_label' isn't referenced.
//                    ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase#_count.
  }
  
  class SameLibraryOverride extends PrivateBase {
//      ^^^^^^^^^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/SameLibraryOverride#
//      relationship scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase# implementation
//                                  ^^^^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase#
    @override
//   ^^^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`annotations.dart`/override.
    int _tick() => 1;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/SameLibraryOverride#_tick().
//      relationship scip-dart pub dart_test 1.0.0 lib/`private_overrides.dart`/PrivateBase#_tick(). implementation reference
//      diagnostic Warning:
//      > The declaration '_tick' isn't referenced.
  }
  
