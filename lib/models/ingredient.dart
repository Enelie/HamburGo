class Ingredient {
  final String id;
  final String name;
  final double price;
  int stock;
  bool available;

  Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.available = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'stock': stock,
    'available': available ? 1 : 0,
  };

  factory Ingredient.fromMap(Map<String, dynamic> m) => Ingredient(
    id: m['id'],
    name: m['name'],
    price: (m['price'] as num).toDouble(),
    stock: m['stock'] as int,
    available: (m['available'] ?? 1) == 1,
  );
}
