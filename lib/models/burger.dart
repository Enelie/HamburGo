class Burger {
  final String id;
  final String name;
  final double basePrice;
  final Map<String,int> extras; // ingredientId -> qty

  Burger({
    required this.id,
    required this.name,
    required this.basePrice,
    Map<String,int>? extras,
  }) : extras = extras ?? {};

  get description => null;

  double totalPrice(Map<String, dynamic> ingredientLookup) {
    double total = basePrice;
    extras.forEach((id, qty){
      final ing = ingredientLookup[id];
      if (ing != null) total += (ing.price as double) * qty;
    });
    return total;
  }
}
