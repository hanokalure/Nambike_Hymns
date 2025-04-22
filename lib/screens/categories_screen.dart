import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'favourites_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final List<String> favoriteSongs;
  final List<Map<String, dynamic>> songs;
  final Function(String) onToggleFavorite;

  const CategoriesScreen({
    super.key,
    required this.favoriteSongs,
    required this.songs,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Hindi',
      'Kannada',
      'English',
      'Tamil',
      'Telugu',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            color: const Color(0xFF3498DB),
            padding: const EdgeInsets.only(top: 50),
            alignment: Alignment.center,
            child: Text(
              'Categories',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    title: Text(
                      categories[index],
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            initialFavorites: favoriteSongs,
                          ),
                        ),
                      );
                    },
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
      height: 82,
      color: const Color(0xFF3498DB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(
                    initialFavorites: favoriteSongs,
                  ),
                ),
              );
            },
            child: _buildNavButton(Icons.music_note, 'Songs'),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => FavouritesScreen(
                    favoriteSongs: favoriteSongs,
                    songs: songs,
                    onRemoveFavorite: onToggleFavorite,
                  ),
                ),
              );
            },
            child: _buildNavButton(Icons.favorite, 'Favorites'),
          ),
          InkWell(
            onTap: () {
              // Already on categories screen
            },
            child: _buildNavButton(Icons.category, 'Categories'),
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
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
