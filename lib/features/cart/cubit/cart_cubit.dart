import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  void addItem({
    required String productId,
    required String name,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) {
    final map = Map<String, CartItem>.from(state.items);
    if (map.containsKey(productId)) {
      final current = map[productId]!;
      map[productId] = current.copyWith(quantity: current.quantity + quantity);
    } else {
      map[productId] = CartItem(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
      );
    }
    emit(state.copyWith(items: map));
  }

  void removeItem(String productId) {
    final map = Map<String, CartItem>.from(state.items);
    map.remove(productId);
    emit(state.copyWith(items: map));
  }

  void increase(String productId) {
    final map = Map<String, CartItem>.from(state.items);
    if (!map.containsKey(productId)) return;
    final c = map[productId]!;
    map[productId] = c.copyWith(quantity: c.quantity + 1);
    emit(state.copyWith(items: map));
  }

  void decrease(String productId) {
    final map = Map<String, CartItem>.from(state.items);
    if (!map.containsKey(productId)) return;
    final c = map[productId]!;
    if (c.quantity <= 1) {
      map.remove(productId);
    } else {
      map[productId] = c.copyWith(quantity: c.quantity - 1);
    }
    emit(state.copyWith(items: map));
  }

  void clearCart() {
    emit(state.copyWith(items: {}));
  }
}