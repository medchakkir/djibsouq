import 'package:flutter/material.dart';
import 'package:dj/data/product_repository.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/layouts/web/pages_web/detail_product_popup.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

/// Opens a dialog showing detailed information about [product].
void openProductPopup(BuildContext context, Product product) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: DetailProductPopup(product: product),
      );
    },
  );
}

class ProductsWeb extends StatefulWidget {
  final String? initialCategory;
  
  const ProductsWeb({super.key, this.initialCategory});

  @override
  State<ProductsWeb> createState() => _ProductsWebState();
}

class _ProductsWebState extends State<ProductsWeb> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    for (var product in ProductRepository.products) {
      _sectionKeys.putIfAbsent(product.category, () => GlobalKey());
    }
    
    if (widget.initialCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCategory(widget.initialCategory!);
      });
    }
  }

  void _scrollToCategory(String category) {
    final key = _sectionKeys[category];
    if (key != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: Column(
        children: [
          buildHeader(currentPage: "Products"),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 260, child: _buildSidebar()),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, top: 40, right: 40, bottom: 40),
                          child: _buildRightContent(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SIDEBAR =================

  Widget _buildSidebar() {
    final categories = _sectionKeys.keys.toList();

    List<Widget> items = [];
    for (int i = 0; i < categories.length; i++) {
      items.add(_CategoryItem(
        category: categories[i],
        onTap: () => _scrollToCategory(categories[i]),
      ));
    }

    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/bg_stars_wb.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  // ================= RIGHT SIDE =================

  Widget _buildRightContent() {
    final Map<String, List<Product>> groupedProducts = {};

    for (var product in ProductRepository.products) {
      groupedProducts.putIfAbsent(product.category, () => []);
      groupedProducts[product.category]!.add(product);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBanner(),
        const SizedBox(height: 40),

        ...groupedProducts.entries.map((entry) {
          return Container(
            key: _sectionKeys[entry.key],
            margin: const EdgeInsets.only(bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(entry.key),
                const SizedBox(height: 25),
                _buildGrid(entry.value),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // ================= BANNER =================

  Widget _buildBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            primaryBlue,
            primaryBlue.withOpacity(0.8),
          ],
        ),
      ),
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "ÉCONOMISEZ 20%\nSUR NOS PRODUITS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(Icons.shopping_bag,
              size: 80, color: Colors.white),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 60,
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 12),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }

  // ================= GRID =================

  Widget _buildGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  // ================= CARD =================

  Widget _buildProductCard(Product product) {
    return _ProductCard(product: product);
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          openProductPopup(context, widget.product);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          child: Container(
          decoration: BoxDecoration(
            color: cardGrey,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.05),
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.product.image,
                      style: const TextStyle(fontSize: 70),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      "\$${widget.product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                        ),
                        onPressed: () {
                          openProductPopup(context, widget.product);
                        },
                        child: const Text("Ajouter"),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    )
     );
  }
}


class _CategoryItem extends StatefulWidget {
  final String category;
  final VoidCallback onTap;

  const _CategoryItem({required this.category, required this.onTap});

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ClipRect(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          transformAlignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.black.withOpacity(0.9) : Colors.transparent,
            border: Border.all(
              color: _isHovered ? Colors.white : Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Text(
                widget.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
