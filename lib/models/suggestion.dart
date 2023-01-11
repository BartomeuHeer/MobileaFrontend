class Suggestion {
  final String? id;
  final String type;
  final String value;

  Suggestion({
    required this.type,
    required this.value,
    this.id = '',
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'],
      type: json['type'],
      value: json['value'],
    );
  }
}