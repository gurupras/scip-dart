part 'private_names_part.dart';

int _helper(int x) => x + 1;

class Holder<T> {
  T _value;
  Holder(this._value);
  Holder._empty(T value) : _value = value;
  T _read() => _value;
}

int usePrivates() => _PartOnly().n + useFromPart();
