class Range {
  final int start;
  final int end;
  final int length;
  Range(this.start, this.end)
      : assert(start <= end),
        length = end - start;
}
