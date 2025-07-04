import 'package:flutter/material.dart';

class SailorMoonEventScreen extends StatelessWidget {
  const SailorMoonEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF2B2A33,
        ).withValues(alpha: 0.95), // meno trasparente
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          '30 ANNI DI SAILOR',
          style: TextStyle(
            color: Color(0xFFFF7CA3),
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2B2A33), Color(0xFF3B3A47)],
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 90, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Event image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/locandine/sailor-moon.jpg',
                    width: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                // const Text(
                //   '30 ANNI DI SAILOR',
                //   style: TextStyle(
                //     fontSize: 28,
                //     fontWeight: FontWeight.bold,
                //     color: Color(0xFFFF7CA3),
                //     letterSpacing: 1.5,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(height: 18),
                // Location & time
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.location_on, color: Colors.white70, size: 20),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Piazza Riccardo Valla 5, Turin',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '3:30 PM – 7:00 PM',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 16),
                // Description
                const Text(
                  'MUFANT celebrates 30 years of Sailor Moon in Italy with talks, stands, and live shows!',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                // Schedule box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFFF7CA3), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'SCHEDULE',
                        style: TextStyle(
                          color: Color(0xFFFF7CA3),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '• 3:40 PM – Opening by MUFANT’s artistic team',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '• 4:00 PM – Book launch: “Nel nome della Luna” with curator Anna Specchio',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '• 5:30 PM – “Appetite of the Warriors” with Chef Ojisan + tasting',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '• 6:15 PM – Martial arts show by Yōshin Ryū',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Extra info
                const Text(
                  'amigurumi, yukata, prints, and\nSpecial display by Leone Locatelli',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Tickets & Info
                const Text(
                  'TICKETS & INFO',
                  style: TextStyle(
                    color: Color(0xFFFF7CA3),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'MUFANT ticket\nStudents: €5 (with ID)\nMuseum Pass not valid',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Info: +39 347 5405096\n+39 349 8171960\ninfo@mufant.it',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}