import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../product/cubit/product_cubit.dart';
import '../pages/product_detail_page.dart';

class CustomerHomeBody extends StatefulWidget {
  const CustomerHomeBody({super.key});

  @override
  State<CustomerHomeBody> createState() => _CustomerHomeBodyState();
}

class _CustomerHomeBodyState extends State<CustomerHomeBody> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cartCubit = context.read<CartCubit>();

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductError) {
          return Center(
            child: Text(
              'Failed to load products 😞\n${state.message}',
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state is ProductLoaded) {
          final allProducts = state.products;

          // ✅ Fixed filtering logic
          final filteredProducts = allProducts.where((product) {
            final matchesFilter = _selectedFilter == 'All';
            final matchesSearch = product.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
            return matchesFilter && matchesSearch;
          }).toList();

          return Column(
            children: [
              // 🔍 Search Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),

              // 🧩 Filter Chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: ['All', 'Men', 'Women', 'Kids', 'Accessories']
                      .map(
                        (filter) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        onSelected: (_) =>
                            setState(() => _selectedFilter = filter),
                        selectedColor:
                        colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),

              const SizedBox(height: 8),

              // 🛍️ Product Grid
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(child: Text("No products found"))
                    : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredProducts.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailPage(itemData: product),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius:
                                const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('\$${product.price.toString()}'),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      minimumSize:
                                      const Size.fromHeight(30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      cartCubit.addItem(
                                        productId: product.id,
                                        name: product.name,
                                        price: product.price,
                                        imageUrl: product.imageUrl,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${product.name} added to cart!",
                                          ),
                                          duration:
                                          const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      size: 18,
                                    ),
                                    label: const Text("Add"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        // 👇 Ensures the function always returns a widget
        return const SizedBox.shrink();
      },
    );
  }
}