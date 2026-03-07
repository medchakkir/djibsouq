import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';

const Color primaryBlue = Color(0xFF1E3A8A); // Couleur principale DjibSouq
const Color accentGreen = Color(0xFF10B981); // Accent vert
const Color lightGrey = Color(0xFFF3F4F6);
const Color textDark = Color(0xFF111827);

class DetailProductPopup extends StatefulWidget {
  final Product product;

  const DetailProductPopup({super.key, required this.product});

  @override
  State<DetailProductPopup> createState() => _DetailProductPopupState();
}

class _DetailProductPopupState extends State<DetailProductPopup>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  int selectedImage = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // overlay sombre
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: screenSize.width * 0.9,
            height: screenSize.height * 0.9,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [

                /// LEFT SIDE (Images)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [

                      /// Main Image
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: lightGrey,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.product.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Thumbnails
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedImage = index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                width: selectedImage == index ? 70 : 60,
                                height: selectedImage == index ? 70 : 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedImage == index
                                        ? primaryBlue
                                        : Colors.grey.shade300,
                                    width: selectedImage == index ? 2 : 1,
                                  ),
                                  boxShadow: selectedImage == index
                                      ? [
                                          BoxShadow(
                                            color: primaryBlue.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    widget.product.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 40),

                /// RIGHT SIDE (Product info)
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Close button
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 28),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Title
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Rating
                      Row(
                        children: const [
                          Icon(Icons.star, color: Color.fromARGB(255, 20, 53, 80), size: 18),
                          Icon(Icons.star, color: Color.fromARGB(255, 20, 53, 80), size: 18),
                          Icon(Icons.star, color: Color.fromARGB(255, 20, 53, 80), size: 18),
                          Icon(Icons.star, color: Color.fromARGB(255, 20, 53, 80), size: 18),
                          Icon(Icons.star_half, color: Color.fromARGB(255, 20, 53, 80), size: 18),
                          SizedBox(width: 6),
                          Text("(12 reviews)")
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Price
                      Text(
                        "\$${widget.product.price}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Description
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.product.description,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Quantity + Buttons
                      Row(
                        children: [
                          /// Quantity selector
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() => quantity--);
                                    }
                                  },
                                ),
                                Text(quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() => quantity++);
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          /// Buy Now
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentGreen,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Buy Now",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// Add to Cart
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 16),
                              side: const BorderSide(color: primaryBlue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(color: primaryBlue),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Delivery info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                          color: lightGrey.withOpacity(0.4),
                        ),
                        child: Column(
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.local_shipping_outlined),
                                SizedBox(width: 10),
                                Text("Free Delivery")
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.assignment_return_outlined),
                                SizedBox(width: 10),
                                Text("Free 30 Days Return")
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
