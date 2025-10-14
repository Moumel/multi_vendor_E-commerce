import 'package:flutter/material.dart';



class VendorItemCard extends StatelessWidget {

  final String name;

  final double price;

  final String imageUrl;

  final VoidCallback onEdit;

  final VoidCallback onDelete;



  const VendorItemCard({

    super.key,

    required this.name,

    required this.price,

    required this.imageUrl,

    required this.onEdit,

    required this.onDelete,

  });



  @override

  Widget build(BuildContext context) {

    final color = Theme.of(context).colorScheme;



    return Card(

      color: color.tertiary,

      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      elevation: 3,

      child: Padding(

        padding: const EdgeInsets.all(8.0),

        child: ListTile(

          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          leading: ClipRRect(

            borderRadius: BorderRadius.circular(8),

            child: Image.network(

              imageUrl,

              width: 60,

              height: 60,

              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) => Container(

                width: 60,

                height: 60,

                color: Colors.grey.shade700,

                child: const Icon(Icons.broken_image, color: Colors.white70),

              ),

            ),

          ),

          title: Text(

            name,

            style: TextStyle(

              fontWeight: FontWeight.bold,

              color: color.inversePrimary,

            ),

          ),

          subtitle: Text(

            "\$${price.toStringAsFixed(2)}",

            style: TextStyle(

              color: color.primary.withOpacity(0.8),

              fontSize: 14,

            ),

          ),

          trailing: Wrap(

            spacing: 4,

            children: [

              IconButton(

                onPressed: onEdit,

                icon: const Icon(Icons.edit),

                color: Colors.blueAccent,

                tooltip: 'Edit item',

              ),

              IconButton(

                onPressed: onDelete,

                icon: const Icon(Icons.delete),

                color: Colors.redAccent,

                tooltip: 'Delete item',

              ),

            ],

          ),

        ),

      ),

    );

  }

}