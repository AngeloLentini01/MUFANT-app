import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: PhotoView(
                imageProvider: AssetImage(imagePath),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
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
    // Set the status bar style to be transparent with light content
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
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
                  backgroundColor: Colors.transparent,
                  pinned: false,
                  floating: false,
                  expandedHeight: 100,
                  iconTheme: const IconThemeData(color: Colors.white),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kBlackColor,
                          kBlackColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: const SafeArea(
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Map',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 0,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      // Add bottom padding to ensure content is above bottom navigation
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 16,
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
