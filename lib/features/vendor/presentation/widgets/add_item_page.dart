import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _image;
  bool isLoading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> _uploadItem() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // Basic price validation
    if (double.tryParse(priceController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid price")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final vendorId = FirebaseAuth.instance.currentUser!.uid;
      String imageUrl = "";

      if (_image != null) {
        // Upload image to Firebase Storage
        final fileName = const Uuid().v4();
        final ref = FirebaseStorage.instance.ref().child("vendor_items/$fileName.jpg");
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      } else {
        // Use placeholder image if none is selected
        imageUrl = "https://via.placeholder.com/150";
      }

      final newItem = {
        "id": const Uuid().v4(),
        "name": nameController.text,
        "price": double.tryParse(priceController.text) ?? 0,
        "imageUrl": imageUrl,
        "vendorId": vendorId,
        "createdAt": FieldValue.serverTimestamp(),
      };

      // Add item to Firestore
      await FirebaseFirestore.instance.collection("items").add(newItem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item added successfully!")),
      );

      // Clear the form fields
      nameController.clear();
      priceController.clear();
      setState(() {
        _image = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Failed to add item: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),
      body: SingleChildScrollView( // Changed to SingleChildScrollView for safety
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch items for full width
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Item Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
            ),
            const SizedBox(height: 24),

            // --- FIXED IMAGE INPUT FIELD ---
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150, // Increased height for better visibility
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: Colors.blueGrey.shade200,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_image!, fit: BoxFit.cover),
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: Colors.blueGrey, size: 40),
                    SizedBox(height: 8),
                    Text(
                      "Tap to Select Item Image",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // --- END FIXED IMAGE INPUT FIELD ---

            const SizedBox(height: 30),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _uploadItem,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Add Item",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}