import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luxery/features/vendor/presentation/pages/vendor_profile_page.dart';

import '../../../auth/pressentation/cubits/auth_cubit.dart';

import '../../../cart/widgets/add_product_page.dart';

import '../widgets/vendor_item_card.dart';





class VendorDashboardPage extends StatefulWidget {

  const VendorDashboardPage({super.key});



  @override

  State<VendorDashboardPage> createState() => _VendorDashboardPageState();

}



class _VendorDashboardPageState extends State<VendorDashboardPage> {

  String? vendorId;

  List<Map<String, dynamic>> vendorItems = [];



  @override

  void initState() {

    super.initState();

    final user = context.read<AuthCubit>().currentUser;

    vendorId = user?.uid;

    if (vendorId != null) _loadVendorItems();

  }



  Future<void> _loadVendorItems() async {

    final snapshot = await FirebaseFirestore.instance

        .collection('products')

        .where('vendorId', isEqualTo: vendorId)

        .get();



    setState(() {

      vendorItems = snapshot.docs.map((doc) {

        final data = doc.data();

        data['docId'] = doc.id; // store the Firestore document ID

        return data;

      }).toList();

    });

  }



  Future<void> deleteItem(String docId) async {

    await FirebaseFirestore.instance.collection('products').doc(docId).delete();

    _loadVendorItems();

  }



  @override

  Widget build(BuildContext context) {

    final color = Theme.of(context).colorScheme;



    return Scaffold(

      appBar: AppBar(

        title: const Text("Vendor Dashboard"),

        centerTitle: true,

        backgroundColor: color.secondary,

        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // 3. 🚀 NAVIGATE TO VENDOR PROFILE PAGE
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VendorProfilePage(),
                ),
              );
            },
          ),
          const SizedBox(width: 8), // Add some spacing to the right
        ],

      ),

      body: vendorItems.isEmpty

          ? const Center(child: Text("No items yet. Add your first product!"))

          : RefreshIndicator(

        onRefresh: _loadVendorItems,

        child: ListView.builder(

          padding: const EdgeInsets.all(12),

          itemCount: vendorItems.length,

          itemBuilder: (context, index) {

            final item = vendorItems[index];

            final imageUrl = item['imageUrl'] ?? item['imageurl'] ?? '';



            return VendorItemCard(

              name: item['name'] ?? 'Unnamed Item',

              price: (item['price'] ?? 0).toDouble(),

              imageUrl: imageUrl.isNotEmpty

                  ? imageUrl

                  : 'https://via.placeholder.com/150',

              onEdit: () => ScaffoldMessenger.of(context).showSnackBar(

                const SnackBar(content: Text("Edit coming soon")),

              ),

              onDelete: () => deleteItem(item['docId']),

            );

          },

        ),

      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () async {

          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) => const AddProductPage(),

            ),

          );

          _loadVendorItems(); // refresh after returning

        },

        backgroundColor: color.primary,

        child: const Icon(Icons.add),

      ),

    );

  }

}