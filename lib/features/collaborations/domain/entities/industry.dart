class Industry {
  final String id;
  final String label;

  const Industry({
    required this.id,
    required this.label,
  });
}

class IndustryParent {
  final String name;
  final List<Industry> children;

  const IndustryParent({
    required this.name,
    required this.children,
  });
}
