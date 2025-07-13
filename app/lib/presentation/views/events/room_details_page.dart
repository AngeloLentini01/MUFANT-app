import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/spacing/section.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:app/utils/app_logger.dart';

class RoomDetailsPage extends StatefulWidget {
  final String title;
  const RoomDetailsPage({super.key, required this.title});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  static const backText = Color(0x9A545165);
  static const lightBlack = Color(0x56000000);
  final Logger _logger = AppLogger.getLogger('RoomDetailsPage');

  Map<String, dynamic>? roomData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoomData();
  }

  Future<void> _loadRoomData() async {
    try {
      AppLogger.info(_logger, 'RoomDetailsPage: Loading data for room title: "${widget.title}"');
      
      final data = await DBMuseumActivityManager.getActivityByTitle(
        widget.title,
      );
      
      if (data != null) {
        AppLogger.info(_logger, 'RoomDetailsPage: Successfully loaded room data: "${data['name']}"');
      } else {
        AppLogger.warning(_logger, 'RoomDetailsPage: No room data found for title: "${widget.title}"');
      }
      
      setState(() {
        roomData = data;
        isLoading = false;
      });
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error loading room data',
        e,
        StackTrace.current,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
              color: kPinkColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (roomData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
              color: kPinkColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: Text('Room not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          roomData!['name'] ?? widget.title,
          style: TextStyle(
            color: kPinkColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                roomData!['image_path'] ??
                    "assets/images/starwarsbackground.png",
                fit: BoxFit.cover,
              ),
            ), //background image
            Positioned.fill(child: Container(color: lightBlack)),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      roomData!['image_path'] ??
                          "assets/images/starwarsmap.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  kSpaceBetweenSections,
                  Center(
                    child: Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kPinkColor, // Border color
                                width: 1, // Border width
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.volume_up_outlined,
                                  color: kPinkColor,
                                  size: 30,
                                ),
                                SizedBox(width: 8),
                                const Text(
                                  "listen to the text-to-spech",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  kSpaceBetweenSections,
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backText,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10),
                        child: Text(
                          roomData!['description'] ??
                              'No description available',
                          style: TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyTabBar(backgroundColor: kBlackColor),
    );
  }
}
