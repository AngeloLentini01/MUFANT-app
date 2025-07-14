import 'package:flutter/material.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:photo_view/photo_view.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int selectedTabIndex = 0;

  void _showZoomedImage(String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.black.withValues(alpha: 0.1),
            child: Center(
              child: PhotoView(
                imageProvider: AssetImage(imagePath),
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
                initialScale: PhotoViewComputedScale.contained,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
        ),
        child: Stack(
          children: [
            // Main content with CustomScrollView
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  //TODO: Rivedere appBar
                  backgroundColor: kBlackColor,
                  pinned: false,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: const Text(
                    'Map',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  centerTitle: false,
                  elevation: 0,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Testo di descrizione generale
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                      ),
                      const SizedBox(height: 16),
                      // Testo sopra la prima immagine
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Ground floor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showZoomedImage(
                          'assets/images/map/museum_map1.jpg',
                        ),
                        child: Hero(
                          tag: 'assets/images/map/museum_map1.jpg',
                          child: Image.asset(
                            'assets/images/map/museum_map1.jpg',
                            fit: BoxFit.contain,
                            width: 500,
                            height: 300,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Testo sopra la seconda immagine
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'First floor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showZoomedImage(
                          'assets/images/map/museum_map2.jpg',
                        ),
                        child: Hero(
                          tag: 'assets/images/map/museum_map2.jpg',
                          child: Image.asset(
                            'assets/images/map/museum_map2.jpg',
                            fit: BoxFit.contain,
                            width: 500,
                            height: 300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
