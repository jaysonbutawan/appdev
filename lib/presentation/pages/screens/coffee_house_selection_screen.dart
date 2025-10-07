import 'package:flutter/material.dart';
import 'package:appdev/data/models/coffeehouse.dart';
import 'package:appdev/data/services/coffeehouse_service.dart';

// Your existing API service is used here
final CoffeeHouseApi _api = CoffeeHouseApi();

// --- 1. The Dialog Content Widget ---
Widget _buildCoffeeHouseSelectionDialog(BuildContext context) {
  // Use a Container for styling and to define the height of the bottom sheet.
  // We use DraggableScrollableSheet so the user can drag it up/down if needed,
  // and it handles the initial height.
  return DraggableScrollableSheet(
    initialChildSize: 0.6, // Start at 60% of screen height
    minChildSize: 0.3,
    maxChildSize: 0.9,
    expand: false, // Must be false for a modal bottom sheet
    builder: (context, scrollController) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Dialog background color
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            // Grab bar and Title
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Select Coffee House",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Divider for visual separation
            const Divider(height: 1, thickness: 1),

            // FutureBuilder to load the list of coffee houses
            Expanded(
              child: FutureBuilder<List<CoffeeHouse>>(
                future: _api.getAllCoffeeHouses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  
                  final houses = snapshot.data ?? [];
                  if (houses.isEmpty) {
                    return const Center(child: Text("No coffee houses available"));
                  }

                  return ListView.builder(
                    controller: scrollController, // Important: Connect scrollController
                    itemCount: houses.length,
                    itemBuilder: (context, index) {
                      final house = houses[index];
                      return ListTile(
                        title: Text(house.name),
                        subtitle: Text(house.address),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Close the dialog and return the selected house
                          Navigator.pop(context, house); 
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}


// --- 2. The Callable Function ---
// This function shows the dialog and returns the selected CoffeeHouse object.
Future<CoffeeHouse?> showCoffeeHouseSelectionDialog(BuildContext context) {
  return showModalBottomSheet<CoffeeHouse>(
    context: context,
    isScrollControlled: true, // Allows the sheet to take up more screen space
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      // Return the dialog content widget
      return _buildCoffeeHouseSelectionDialog(context);
    },
  );
}