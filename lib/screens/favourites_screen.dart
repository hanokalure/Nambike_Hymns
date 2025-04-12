import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'playlist_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  final List<String> favouriteSongs = const [
    'Amazing Grace',
    'It Is Well With My Soul',
    'How Great Thou Art',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Navbar
          Container(
            width: double.infinity,
            height: 120,
            color: const Color(0xFF3498DB),
            padding: const EdgeInsets.only(top: 50),
            alignment: Alignment.center,
            child: Text(
              'Favourites',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Song List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favouriteSongs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3498DB),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          favouriteSongs[index],
                          style: GoogleFonts.montserrat(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 72,
      color: const Color(0xFF3498DB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            child: _buildNavButton(Icons.music_note, 'Songs'),
          ),
          InkWell(
            onTap: () {}, // Already on Favourites
            child: _buildNavButton(Icons.favorite, 'Favorites'),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PlaylistScreen()),
              );
            },
            child: _buildNavButton(Icons.playlist_play, 'Playlist'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
