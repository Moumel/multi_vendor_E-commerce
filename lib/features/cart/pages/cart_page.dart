import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        backgroundColor: colorScheme.secondary,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty 🛒",
                style: TextStyle(color: colorScheme.inversePrimary, fontSize: 18),
              ),
            );
          }

          return Column(
            children: [
              // List of cart items
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items.values.toList()[index];
                    return CartItemTile(item: item);
                  },
                ),
              ),

              // Total and checkout area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total (${state.totalItems} items)',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.inversePrimary,
                          ),
                        ),
                        Text(
                          '\$${state.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                            ),
                            onPressed: () {
                              context.read<CartCubit>().clearCart();
                            },
                            child: const Text('Clear Cart'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                            ),
                            onPressed: () {
                              // For now, just show a snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Checkout coming soon!")),
                              );
                            },
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}