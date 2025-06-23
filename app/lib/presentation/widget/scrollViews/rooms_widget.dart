import 'package:app/presentation/components/scrollViews/items/room_card.dart';
import 'package:flutter/material.dart';

class RoomsWidget extends StatelessWidget {
  const RoomsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          RoomCard(title: 'Star Wars', imagePath: 'assets/images/starwars.jpg'),
          const SizedBox(width: 12), // Add spacing with SizedBox
          RoomCard(title: 'Library', imagePath: 'assets/images/library.jpg'),
          const SizedBox(width: 12), // Add spacing with SizedBox
          RoomCard(
            title: 'Superheroes',
            imagePath: 'assets/images/superhero.jpg',
          ),
        ],
      ),
    );
  }
}
