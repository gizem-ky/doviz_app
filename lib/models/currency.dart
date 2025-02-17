class Currency {
  final String name;
  final double rate;

  Currency({required this.name, required this.rate});

  // JSON'dan Currency modeline dönüşüm
  factory Currency.fromJson(Map<String, dynamic> json, String name) {
    return Currency(
      name: name,
      rate: (json['rate'] as num).toDouble(),
    );
  }
}
