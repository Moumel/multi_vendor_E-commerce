import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerFeedPage extends StatefulWidget {
  const CustomerFeedPage({super.key});

  @override
  State<CustomerFeedPage> createState() => _CustomerFeedPageState();
}

class _CustomerFeedPageState extends State<CustomerFeedPage> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final List<String> categories = ['All', 'Men', 'Women', 'Kids', 'Tech', 'Home', 'Other'];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        backgroundColor: color.primary,
        title: const Text(
          "L U X U R Y",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  // Navigate to cart page
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: color.surface,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: color.primary),
              child: const Text(
                "Menu",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                // logout logic
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: color.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 🏷️ Category Filter
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => selectedCategory = category);
                      },
                      selectedColor: color.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : color.onSurface,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 📰 Feed
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('items').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No products available yet.'));
                  }

                  final allItems = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                  // Filter logic
                  final filteredItems = allItems.where((item) {
                    final name = item['name']?.toString().toLowerCase() ?? '';
                    final category = item['category']?.toString().toLowerCase() ?? '';
                    final query = searchQuery.toLowerCase();

                    final matchesSearch = name.contains(query);
                    final matchesCategory = selectedCategory == 'All' ||
                        category == selectedCategory.toLowerCase();

                    return matchesSearch && matchesCategory;
                  }).toList();

                  return ListView(
                    children: [
                      // 🧾 Ad banner (only once)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: NetworkImage("https://via.placeholder.com/600x200?text=Luxury+Ad+Banner"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // 🛍️ Grid items (2 per row)
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredItems.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return GestureDetector(
                            onTap: () {
                              // open product detail
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.surface,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.network(
                                        item['imageUrl'] ?? '',
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey.shade800,
                                          child: const Icon(Icons.broken_image, color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'] ?? 'Unnamed',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "\$${item['price'] ?? 0}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
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
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: color.surface,
        selectedItemColor: color.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}