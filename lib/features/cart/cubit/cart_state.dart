import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [productId, name, price, imageUrl, quantity];
}

class CartState extends Equatable {
  final Map<String, CartItem> items; // keyed by productId

  const CartState({required this.items});

  factory CartState.initial() => const CartState(items: {});

  int get totalItems =>
      items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.values.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  CartState copyWith({Map<String, CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}