import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${item.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  color: colorScheme.primary,
                  onPressed: () => context.read<CartCubit>().decrease(item.productId),
                ),
                Text(
                  '${item.quantity}',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.inversePrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: colorScheme.primary,
                  onPressed: () => context.read<CartCubit>().increase(item.productId),
                ),
              ],
            ),

            // Delete Button
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade300),
              onPressed: () => context.read<CartCubit>().removeItem(item.productId),
            ),
          ],
        ),
      ),
    );
  }
}