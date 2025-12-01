import 'package:flutter/material.dart';
import '../data/repository.dart';
import '../models/ingredient.dart';
import '../models/burger.dart';
import '../models/order.dart';

class AppProvider extends ChangeNotifier {
  final Repository repo = Repository();
  bool initialized = false;

  // Editor state
  Burger? currentBurger;

  // Inicialización del provider
  Future<void> init() async {
    await repo.init();
    initialized = true;

    // Crear hamburguesa por defecto si no existe
    currentBurger ??= Burger(
      id: 'default',
      name: 'Mi Hamburguesa',
      basePrice: 5.0,
    );

    notifyListeners();
  }

  // Obtener ingredientes disponibles
  List<Ingredient> get ingredients => repo.getAllIngredients();

  // Método interno para asegurar que currentBurger nunca sea null
  Burger _safeBurger() {
    if (currentBurger == null) {
      currentBurger = Burger(
        id: 'default',
        name: 'Mi Hamburguesa',
        basePrice: 5.0,
      );
    }
    return currentBurger!;
  }

  // Activar o desactivar ingrediente extra
  void toggleExtra(String ingredientId) {
    final burger = _safeBurger();
    final qty = burger.extras[ingredientId] ?? 0;

    if (qty == 0) {
      burger.extras[ingredientId] = 1;
    } else {
      burger.extras.remove(ingredientId);
    }

    notifyListeners();
  }

  // Cambiar cantidad de un ingrediente extra
  void setExtraQty(String ingredientId, int qty) {
    final burger = _safeBurger();

    if (qty <= 0) {
      burger.extras.remove(ingredientId);
    } else {
      burger.extras[ingredientId] = qty;
    }

    notifyListeners();
  }

  // Precio actual de la hamburguesa con extras
  double get currentPrice {
    final burger = _safeBurger();
    final map = <String, dynamic>{};
    for (var i in ingredients) {
      map[i.id] = i;
    }
    return burger.totalPrice(map);
  }

  // Crear orden y guardarla en repository
  Future<Order> placeOrder({DateTime? scheduled}) async {
    final burger = _safeBurger();
    final order = await repo.createOrder(burger, scheduled: scheduled);
    notifyListeners();
    return order;
  }

  // Actualizar ingrediente
  Future<void> updateIngredient(Ingredient ing) async {
    await repo.updateIngredient(ing);
    notifyListeners();
  }

  // Obtener todas las órdenes
  List<Order> get orders => repo.getOrders();

  // Agregar reseña
  Future<void> addReview(r) => repo.addReview(r);

  // Obtener precio de un ingrediente (puedes completar si necesitas)
  double getIngredientPrice(String ingredientId) {
    final ing = ingredients.firstWhere(
      (i) => i.id == ingredientId,
      orElse: () => Ingredient(id: ingredientId, name: 'Desconocido', price: 0, stock: 0),
    );
    return ing.price;
  }

  // Actualizar cantidad de un extra (si se requiere)
  void updateExtraQuantity(String id, int newQty) {
    final burger = _safeBurger();
    if (newQty <= 0) {
      burger.extras.remove(id);
    } else {
      burger.extras[id] = newQty;
    }
    notifyListeners();
  }

  // Guardar hamburguesa y orden en Supabase (placeholder)
  Future<void> saveBurgerToSupabase({
    required String orderId,
    DateTime? scheduledAt,
  }) async {
    // TODO: implementar la inserción en Supabase usando repo o SupabaseProvider
  }
}
