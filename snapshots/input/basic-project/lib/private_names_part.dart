part of 'private_names.dart';

class _PartOnly {
  int n = 0;
}

int useFromPart() => _helper(1) + Holder<int>._empty(2)._read();
