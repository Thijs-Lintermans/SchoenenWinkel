class Schoen {
  String id;
  String naam;
  String merk;
  String description;
  double prijs;
  String imageUrl;

  Schoen({
    required this.id,
    required this.naam,
    required this.merk,
    required this.description,
    required this.prijs,
    required this.imageUrl,
  });

  factory Schoen.fromJson(Map<String, dynamic> json) {
    return Schoen(
      id: json['id'],
      naam: json['name'],
      merk: json['merk'] ?? 'Onbekend merk', // Voorzie een fallback
      description: json['description'] ?? 'Geen beschrijving beschikbaar',
      prijs: json['price']?.toDouble() ?? 0.0, // Converteer prijs naar double
      imageUrl: json['imageUrl'] ?? '', // Voorzie een lege string als fallback
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': naam,
        'merk': merk,
        'description': description,
        'price': prijs,
        'imageUrl': imageUrl,
      };
}
