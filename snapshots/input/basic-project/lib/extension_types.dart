// @dart=3.3
extension type Meters(double value) {
  Meters twice() => Meters(value * 2);
}

extension type const Token._(String text) {
  factory Token.of(String text) => Token._(text.trim());
}

double total(Meters a, Token t) => a.twice().value + t.text.length;
