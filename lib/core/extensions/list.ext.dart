extension ListUtils<T extends double> on List<T> {
  double get median {
    final copy = [...this]..sort((a, b) => (a - b).toInt());
    final middle = copy.length ~/ 2;
    return copy.length % 2 == 0
        ? (copy[middle - 1] + copy[middle]) / 2
        : copy[middle];
  }
}
