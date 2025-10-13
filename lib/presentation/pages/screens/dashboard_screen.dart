import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appdev/data/services/category_service.dart';
import 'package:appdev/data/models/coffee.dart';
import 'package:appdev/data/services/coffee_service.dart';
import 'package:appdev/presentation/pages/cards/coffee_card.dart';
import 'package:appdev/presentation/widgets/search_bar.dart';
import 'package:appdev/presentation/pages/wrappers/draggable_fab_wrapper.dart';
import 'package:appdev/presentation/pages/screens/add_cart_screen.dart';
import 'package:appdev/presentation/pages/screens/user_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final User _user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Coffee>> _coffeeFuture;
late Future<List<String>> _categoryFuture;

  List<Coffee> _allCoffees = [];
  List<Coffee> _filteredCoffees = [];
  List<String> _categories = ["All"]; // Default while loading

  int _selectedCategoryIndex = 0; // Default = "All"

@override
  void initState() {
    super.initState();
    _coffeeFuture = CoffeeApi().getAllCoffees();
    _categoryFuture = CategoryService().getAllCategories();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final coffees = await _coffeeFuture;
      final categories = await _categoryFuture;

      setState(() {
        _allCoffees = coffees;
        _filteredCoffees = coffees;
        _categories = categories;
      });
    } catch (e) {
      debugPrint("Error initializing data: $e");
    }
  }

  void _filterCoffees(String query) {
    setState(() {
      final selectedCategory = _categories[_selectedCategoryIndex];
      _filteredCoffees = _allCoffees.where((c) {
        final matchesSearch = c.name.toLowerCase().contains(query.toLowerCase());
        final matchesCategory = selectedCategory == "All" ||
            c.category.toLowerCase() == selectedCategory.toLowerCase();
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    _filterCoffees(_searchController.text);
  }

  void _resetSearch() {
    setState(() {
      _searchController.clear();
    });
    _filterCoffees('');
  }

 Widget _buildTopBar() {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF9A00),
                  width: 2, // ✅ border width
                ),
              ),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.09,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _user.photoURL != null
                    ? NetworkImage(_user.photoURL!)
                    : const AssetImage("assets/images/default_avatar.png")
                        as ImageProvider,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFFFF9A00)),
            iconSize: 36,
            onPressed: () => Get.to(() => const AddCartScreen()),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildSearchBar() {
    return AnimatedSearchBar(
      width: 350,
      textController: _searchController,
      onSuffixTap: _resetSearch,
      onChanged: _filterCoffees,
    );
  }

  Widget _buildCategorySelector() {
  return SizedBox(
    height: 60,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final isSelected = _selectedCategoryIndex == index;
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 16 : 8,
            right: index == _categories.length - 1 ? 16 : 8,
            top: 8,
            bottom: 8,
          ),
          child: GestureDetector(
            onTap: () => _onCategorySelected(index),
            child: IntrinsicWidth( 
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, 
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 113, 52, 2)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF9A00)
                        : const Color(0xFFFF9A00),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    _categories[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color.fromARGB(255, 113, 52, 2),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}


  Widget _buildCoffeeGrid() {
    return FutureBuilder<List<Coffee>>(
      future: _coffeeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (_filteredCoffees.isEmpty) {
          return const Center(child: Text("No coffees found"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: _filteredCoffees.length,
          itemBuilder: (context, index) {
            final coffee = _filteredCoffees[index];
            return CoffeeCard(
              description: coffee.description,
              id: coffee.id,
              name: coffee.name,
              imageBytes: coffee.imageBytes,
              category: coffee.category,
              price: coffee.price,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              _buildTopBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    _buildCategorySelector(), // ✅ Added here
                    const SizedBox(height: 16),
                    Expanded(child: _buildCoffeeGrid()),
                  ],
                ),
              ),
              const DraggableFabWrapper(),
            ],
          ),
        ),
      ),
    );
  }
}
