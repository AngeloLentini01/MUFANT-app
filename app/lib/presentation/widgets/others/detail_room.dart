import 'dart:convert';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/widgets/bars/home_page_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailRoom extends StatefulWidget {
  final String name;
  const DetailRoom({super.key, required this.name});

  @override
  State<DetailRoom> createState() => _DetailRoomState();
}

class _DetailRoomState extends State<DetailRoom> {
  static const blueColor = Color.fromARGB(255, 28, 28, 50);
  static const backText = Color(0x9A545165);
  static const lightBlack = Color(0x56000000);
  static const kBlankSpaceWidget = SizedBox(height: 24);
  static const buttonText = "listen to the text-to-spech";

  List<dynamic> _rooms = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/json_detail_room/json_detail_room.json',
      ); //richiamiamo il Json
      final data = json.decode(response);
      setState(() {
        _rooms = data['rooms'];
      });
    } catch (e) {
      setState(() {
        _error = 'Errore nel caricamento della stanza: ${e.toString()}';
      });
    }
  }

  Map<String, dynamic>? getRoomByName(String name) {
    return _rooms.cast<Map<String, dynamic>?>().firstWhere(
      (room) => room?['name'] == name,
      orElse: () => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = getRoomByName(widget.name);
    if (_error.isNotEmpty) {
      return Center(child: Text(_error));
    }
    if (room == null) {
      return Center(child: Text('Room not found'));
    }

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(room['roomAssetBG'], fit: BoxFit.cover),
            ),
            Positioned.fill(child: Container(color: lightBlack)),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: blueColor,
                  pinned: true,
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      room['name'],
                      style: TextStyle(
                        color: kPinkColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          room['roomAssetMap'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      kBlankSpaceWidget,
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
                                    color: kPinkColor,
                                    width: 1,
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
                                      buttonText,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      kBlankSpaceWidget,
                      Padding(
                        padding: EdgeInsets.all(25),
                        child: Container(
                          decoration: BoxDecoration(
                            color: backText,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                            child: Text(
                              room['roomText'],
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
          ],
        ),
      ),
      bottomNavigationBar: HomePageBottomNavBar(backgroundColor: kBlackColor),
    );
  }
}
