import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class GroceryPlannerPage extends StatefulWidget {
  const GroceryPlannerPage({super.key});

  @override
  State<GroceryPlannerPage> createState() => _GroceryPlannerPageState();
}

class _GroceryPlannerPageState extends State<GroceryPlannerPage> {
  final _budgetController = TextEditingController();
  final List<String> _categories = ['Meat', 'Dairy', 'Beverage', 'Produce', 'Snacks', 'Pantry'];
  final Set<String> _selectedCategories = {};
  
  List<Map<String, dynamic>> _generatedList = [];
  bool _isGenerating = false;

  void _generateList() {
    final budgetText = _budgetController.text;
    final budget = double.tryParse(budgetText);
    
    if (budget == null || budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid budget')));
      return;
    }
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one category')));
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedList.clear();
    });

    // Mock AI generation logic
    Future.delayed(const Duration(seconds: 1), () {
      final random = Random();
      double currentTotal = 0;
      List<Map<String, dynamic>> items = [];

      final catalog = {
        'Meat': [
          {'name': 'Chicken Breast (1kg)', 'price': 250.0},
          {'name': 'Ground Pork (500g)', 'price': 180.0},
          {'name': 'Beef Short Ribs (1kg)', 'price': 450.0},
          {'name': 'Hotdogs (1 pack)', 'price': 120.0},
        ],
        'Dairy': [
          {'name': 'Fresh Milk (1L)', 'price': 110.0},
          {'name': 'Cheddar Cheese (200g)', 'price': 150.0},
          {'name': 'Butter (225g)', 'price': 130.0},
          {'name': 'Eggs (1 Dozen)', 'price': 105.0},
        ],
        'Beverage': [
          {'name': 'Orange Juice (1L)', 'price': 90.0},
          {'name': 'Instant Coffee (Pack)', 'price': 140.0},
          {'name': 'Soda (1.5L)', 'price': 75.0},
          {'name': 'Bottled Water (6L)', 'price': 80.0},
        ],
        'Produce': [
          {'name': 'Onion & Garlic Pack', 'price': 60.0},
          {'name': 'Potatoes (1kg)', 'price': 85.0},
          {'name': 'Carrots (1kg)', 'price': 95.0},
          {'name': 'Tomatoes (500g)', 'price': 50.0},
          {'name': 'Apples (1kg)', 'price': 150.0},
        ],
        'Snacks': [
          {'name': 'Potato Chips', 'price': 45.0},
          {'name': 'Chocolate Biscuits', 'price': 55.0},
          {'name': 'Mixed Nuts', 'price': 120.0},
        ],
        'Pantry': [
          {'name': 'White Rice (5kg)', 'price': 280.0},
          {'name': 'Cooking Oil (1L)', 'price': 110.0},
          {'name': 'Soy Sauce (500ml)', 'price': 40.0},
          {'name': 'Vinegar (500ml)', 'price': 35.0},
          {'name': 'Sugar (1kg)', 'price': 70.0},
          {'name': 'Salt (1kg)', 'price': 45.0},
        ],
      };

      // Loop through selected categories and pick random items until budget is hit
      int attempts = 0;
      while (currentTotal < budget && attempts < 50) {
        final catList = _selectedCategories.toList();
        final randomCat = catList[random.nextInt(catList.length)];
        final availableItems = catalog[randomCat]!;
        final item = availableItems[random.nextInt(availableItems.length)];

        if (currentTotal + (item['price'] as double) <= budget) {
          // Check if already in list to just increase quantity
          int index = items.indexWhere((i) => i['name'] == item['name']);
          if (index != -1) {
            items[index]['qty'] += 1;
          } else {
            items.add({'name': item['name'], 'price': item['price'], 'category': randomCat, 'qty': 1});
          }
          currentTotal += (item['price'] as double);
        }
        attempts++;
      }

      if (mounted) {
        setState(() {
          _generatedList = items;
          _isGenerating = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Smart Grocery List', style: GoogleFonts.dmSerifDisplay(color: AppTheme.textDark)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter your Budget',
                prefixText: '₱ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select Categories:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _categories.map((cat) {
                final isSelected = _selectedCategories.contains(cat);
                return FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(cat);
                      } else {
                        _selectedCategories.remove(cat);
                      }
                    });
                  },
                  selectedColor: AppTheme.emLt,
                  checkmarkColor: AppTheme.emDk,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isGenerating ? null : _generateList,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.emDk,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isGenerating 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Generate List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 24),
            if (_generatedList.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Generated List', style: GoogleFonts.dmSerifDisplay(fontSize: 20)),
                  Text('Total: ₱${_generatedList.fold<double>(0, (sum, item) => sum + (item['price'] * item['qty'])).toStringAsFixed(2)}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.emDk)
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _generatedList.length,
                  itemBuilder: (context, index) {
                    final item = _generatedList[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppTheme.emLt),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.emXlt,
                          child: Text('${item['qty']}x', style: const TextStyle(fontSize: 12, color: AppTheme.emDk, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Text(item['category'], style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        trailing: Text('₱${(item['price'] * item['qty']).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
