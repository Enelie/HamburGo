import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/ingredient.dart';
import '../models/burger.dart';
import '../models/order.dart';
import '../models/review.dart';

class Repository {
  static final Repository _instance = Repository._internal();
  factory Repository() => _instance;
  Repository._internal();

  final Uuid _uuid = Uuid();
  final Map<String, Ingredient> _ingredients = {};
  final List<Order> _orders = [];
  final List<Review> _reviews = [];

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    // try load ingredients
    final ingJson = sp.getString('ingredients_v1');
    if (ingJson == null) {
      // seed sample ingredients
      _seedIngredients();
      await _saveIngredients(sp);
    } else {
      final list = jsonDecode(ingJson) as List<dynamic>;
      for (var item in list) {
        final ing = Ingredient.fromMap(Map<String,dynamic>.from(item));
        _ingredients[ing.id] = ing;
      }
    }
    // reviews
    final revJson = sp.getString('reviews_v1');
    if (revJson != null) {
      final list = jsonDecode(revJson) as List<dynamic>;
      for (var item in list) {
        final m = Map<String,dynamic>.from(item);
        _reviews.add(Review(
          id: m['id'],
          orderId: m['orderId'],
          rating: m['rating'],
          comment: m['comment'],
          date: DateTime.parse(m['date']),
        ));
      }
    }
  }

  void _seedIngredients() {
    final base = [
      Ingredient(id: _uuid.v4(), name: 'Queso', price: 0.8, stock: 20),
      Ingredient(id: _uuid.v4(), name: 'Tocino', price: 1.2, stock: 10),
      Ingredient(id: _uuid.v4(), name: 'Lechuga', price: 0.3, stock: 30),
      Ingredient(id: _uuid.v4(), name: 'Tomate', price: 0.4, stock: 25),
      Ingredient(id: _uuid.v4(), name: 'Cebolla', price: 0.25, stock: 25),
      Ingredient(id: _uuid.v4(), name: 'Huevo', price: 0.9, stock: 15),
      Ingredient(id: _uuid.v4(), name: 'Pepinillo', price: 0.2, stock: 25),
      Ingredient(id: _uuid.v4(), name: 'Salchicha', price: 5, stock: 20),
    ];
    for (var i in base) _ingredients[i.id] = i;
  }

  Map<String, Ingredient> getAllIngredientsMap() => Map.from(_ingredients);
  List<Ingredient> getAllIngredients() => _ingredients.values.toList();

  Future<void> updateIngredient(Ingredient i) async {
    _ingredients[i.id] = i;
    final sp = await SharedPreferences.getInstance();
    await _saveIngredients(sp);
  }

  Future<void> _saveIngredients(SharedPreferences sp) async {
    final arr = _ingredients.values.map((e) => e.toMap()).toList();
    await sp.setString('ingredients_v1', jsonEncode(arr));
  }

  // Orders
  Future<Order> createOrder(Burger burger, {DateTime? scheduled}) async {
    final id = _uuid.v4();
    final order = Order(
      id: id,
      burger: burger,
      createdAt: DateTime.now(),
      scheduledAt: scheduled,
    );
    _orders.add(order);
    return order;
  }

  List<Order> getOrders() => List.unmodifiable(_orders);

  // Reviews
  Future<void> addReview(Review r) async {
    _reviews.add(r);
    final sp = await SharedPreferences.getInstance();
    await sp.setString('reviews_v1', jsonEncode(_reviews.map((e) => e.toMap()).toList()));
  }

  List<Review> getReviews() => List.unmodifiable(_reviews);
}
