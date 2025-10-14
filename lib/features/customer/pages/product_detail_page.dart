import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../home/model/product_model.dart';



class ProductDetailPage extends StatelessWidget {
  final ProductModel itemData;

  const ProductDetailPage({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final cartCubit = context.read<CartCubit>();

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        title: Text(itemData.name),
        backgroundColor: color.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                itemData.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // ️ Product Name
            Text(
              itemData.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),

            //  Price
            Text(
              "\$${itemData.price.toString()}",
              style: TextStyle(
                color: color.primary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            //  Description
            Text(
              itemData.description ?? "No description available.",
              style: TextStyle(
                fontSize: 15,
                color: color.onSurface.withOpacity(0.8),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart_outlined),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  cartCubit.addItem(
                    productId: itemData.id,
                    name: itemData.name,
                    price: itemData.price,
                    imageUrl: itemData.imageUrl,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${itemData.name} added to cart!"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}