// Members of unnamed extensions are named under `<extension on T>(k)`, where k
// ranks the file's unnamed extensions on the same type.
extension on List<int> {
  int twice() => 2;
  int get label => 1;
}

extension on Set<int> {
  int twice() => 3;
  int get label => 2;
}

extension on List<int> {
  int thrice() => 3;
}

int get label => 0;

int useUnnamedExtensions() =>
    [1].twice() + {1}.twice() + [1].label + {1}.label + label + [1].thrice();
