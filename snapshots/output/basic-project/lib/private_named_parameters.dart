  // @dart=3.13
// definition scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/
  class Account {
//      ^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#
    final String _owner;
//        ^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`string.dart`/String#
//               ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#_owner.
    final int _balance;
//        ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//            ^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#_balance.
    Account({required this._owner, this._balance = 0});
//  ^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#`<constructor>`().
//                         ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#_owner.
//                         ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#`<constructor>`().(owner)
//                                      ^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#_balance.
//                                      ^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#`<constructor>`().(balance)
  
    String describe() => '$_owner: $_balance';
//  ^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`string.dart`/String#
//         ^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#describe().
//                         ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#_owner.
//                                  ^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#_balance.
  }
  
  Account open() => Account(owner: 'a', balance: 1);
//^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#
//        ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/open().
//                  ^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#`<constructor>`().
//                          ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#`<constructor>`().(owner)
//                                      ^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`private_named_parameters.dart`/Account#`<constructor>`().(balance)
  
