import 'package:dj/pages/categories_product_page.dart';
import 'package:flutter/material.dart';
import 'categories.dart';
import 'products.dart';
import 'drawer.dart';

// Color constants
const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ValueNotifier<int> _currentOnboarding;

  @override
  void initState() {
    super.initState();
    _currentOnboarding = ValueNotifier(0);
  }

  @override
  void dispose() {
    _currentOnboarding.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _searchBar(),
                    const SizedBox(height: 20),
                    _onboardingBanner(),
                    const SizedBox(height: 24),
                    _sectionTitle("Categories"),
                    const SizedBox(height: 12),
                    _categoriesPreview(context),
                    const SizedBox(height: 32),
                    ProductsHorizontalList(
                      title: "Électronique",
                      products: ProductsData.getProductsByCategory(
                        'Électronique',
                      ),
                    ),
                    const SizedBox(height: 32),
                    ProductsHorizontalList(
                      title: "Vêtements",
                      products: ProductsData.getProductsByCategory('Vêtements'),
                    ),
                    const SizedBox(height: 32),
                    ProductsHorizontalList(
                      title: "Maison",
                      products: ProductsData.getProductsByCategory('Maison'),
                    ),
                    const SizedBox(height: 32),
                    ProductsHorizontalList(
                      title: "Sports",
                      products: ProductsData.getProductsByCategory('Sports'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
          icon: Icon(Icons.search),
          suffixIcon: Icon(Icons.mic),
        ),
      ),
    );
  }

  Widget _onboardingBanner() {
    final pageController = PageController(viewportFraction: 0.9);

    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _currentOnboarding,
          builder: (_, value, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: value == index ? 18 : 6,
                  decoration: BoxDecoration(
                    color: value == index
                        ? primaryBlue
                        : primaryBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: pageController,
            itemCount: 3,
            onPageChanged: (index) {
              _currentOnboarding.value = index;
            },
            itemBuilder: (_, index) {
              final banners = [
                {
                  'title': 'Big Sale Today',
                  'subtitle': 'Up to 50% discount\non selected items',
                  'image':
                      'https://via.placeholder.com/500x300/1E3A8A/FFFFFF?text=Big+Sale',
                },
                {
                  'title': 'New Arrivals',
                  'subtitle': 'Check out our latest\nproducts',
                  'image':
                      'https://via.placeholder.com/500x300/1E3A8A/FFFFFF?text=New+Arrivals',
                },
                {
                  'title': 'Free Delivery',
                  'subtitle': 'On orders over 50\nFree shipping',
                  'image':
                      'https://via.placeholder.com/500x300/1E3A8A/FFFFFF?text=Free+Delivery',
                },
              ];
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: primaryBlue,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          primaryBlue.withOpacity(0.7),
                          primaryBlue.withOpacity(0.4),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner['subtitle'] as String,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      title: const Text(
        "DJIBSOUQ",
        style: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Widget _categoriesPreview(BuildContext context) {
    final categories = [
      {
        'name': 'Électronique',
        'icon': Icons.devices,
        'image':
            'https://via.placeholder.com/200x200/3B82F6/FFFFFF?text=Electronique',
      },
      {
        'name': 'Vêtements',
        'icon': Icons.shopping_bag,
        'image':
            'https://via.placeholder.com/200x200/EC4899/FFFFFF?text=Vetements',
      },
      {
        'name': 'Maison',
        'icon': Icons.home,
        'image':
            'https://via.placeholder.com/200x200/10B981/FFFFFF?text=Maison',
      },
      {
        'name': 'Sports',
        'icon': Icons.sports_soccer,
        'image':
            'https://via.placeholder.com/200x200/F59E0B/FFFFFF?text=Sports',
      },
    ];

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (_, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryProductsPage(
                      categoryName: category['name'] as String,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            category['icon'] as IconData,
                            color: primaryBlue,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            category['name'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoriesPage()),
            );
          },
          child: Text(
            'Voir toutes les catégories →',
            style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
