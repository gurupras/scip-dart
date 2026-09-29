// @dart=3.13
class Account {
  final String _owner;
  final int _balance;
  Account({required this._owner, this._balance = 0});

  String describe() => '$_owner: $_balance';
}

Account open() => Account(owner: 'a', balance: 1);
