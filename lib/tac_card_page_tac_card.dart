import 'package:flutter/material.dart';
import 'tac_card.dart';

class TacCardPage extends StatefulWidget {
  const TacCardPage({super.key});

  @override
  State<TacCardPage> createState() => _TacCardPageState();
}

class _TacCardPageState extends State<TacCardPage> {
  List<TacCard> availableCards = [];
  List<TacCard> selectedCards = []; // Holds selected cards
  late List<DropdownMenuItem<TacCard>> menuItems = [];

  @override
  Widget build(BuildContext context) {
    for (var tacCard in allTacCards) {
      availableCards.add(tacCard);
      /*
      menuItems.add(DropdownMenuItem<TacCard>(
          value: tacCard,
          child: Text(tacCard.name),
        ));
       */
    }
    menuItems = allTacCards.map<DropdownMenuItem<TacCard>>((TacCard value) {
      return DropdownMenuItem<TacCard>(
        value: value,
        child: Text(value.name),
      );
    }).toList();

    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage('images/background.png'))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            const Text(
              'Select the Tactical Cards you have at the end of the game:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, backgroundColor: Colors.white),
            ),
            const SizedBox(height: 20),

            // Dropdown for selecting tactical cards
            DropdownButtonFormField<TacCard>(
              value: selectedCards.isEmpty ? null : selectedCards.last,
              onChanged: (TacCard? newValue) {
                debugPrint('onChanged - ${newValue?.name}');
                setState(() {
                  if (newValue != null && !selectedCards.contains(newValue)) {
                    selectedCards.add(newValue);
                  }
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select a Tactical Card',
                border: OutlineInputBorder(),
              ),
              items: menuItems,
            ),

            // Display selected cards
            const SizedBox(height: 20),
            const Text(
              'Selected Cards:',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedCards.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selectedCards[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          selectedCards.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Buttons at the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button to go back to the Money page
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Assuming you want to go back to the previous page
                  },
                  child: const Text('Back'),
                ),
                // Next button to go to the next scoring category
                ElevatedButton(
                  onPressed: () {
                    // You can navigate to the next category or submit the current selections
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NextPage(), // Replace with the next page's route
                      ),
                    );
                     */
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
