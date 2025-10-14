import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final items = state.items.values.toList();
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(item.imageUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.image)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, color: cs.inversePrimary)),
                              const SizedBox(height: 6),
                              Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(color: cs.primary)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(onPressed: () => context.read<CartCubit>().decrease(item.productId), icon: const Icon(Icons.remove_circle_outline)),
                            Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(onPressed: () => context.read<CartCubit>().increase(item.productId), icon: const Icon(Icons.add_circle_outline)),
                          ],
                        ),
                        IconButton(onPressed: () => context.read<CartCubit>().removeItem(item.productId), icon: const Icon(Icons.delete_outline, color: Colors.red)),
                      ],
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: items.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('\$${state.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // For now just clear cart as a mock "checkout"
                              context.read<CartCubit>().clearCart();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed (mock)')));
                              Navigator.pop(context);
                            },
                            child: const Text('Place Order (Mock)'),
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