import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'song_lyrics_screen.dart';

class FavouritesScreen extends StatefulWidget {
  final List<String> favoriteSongs;
  final List<Map<String, dynamic>> songs;
  final Function(String) onRemoveFavorite;

  const FavouritesScreen({
    super.key,
    required this.favoriteSongs,
    required this.songs,
    required this.onRemoveFavorite,
  });

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteSongData = widget.songs.where(
      (song) => widget.favoriteSongs.contains(song['song_title']),
    ).toList();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                'Favourites',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                  return Future.value();
                },
                child: widget.favoriteSongs.isEmpty
                    ? Center(
                        child: Text(
                          'No favorite songs yet',
                          style: GoogleFonts.montserrat(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: favoriteSongData.length,
                        itemBuilder: (context, index) {
                          final song = favoriteSongData[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongLyricsScreen(
                                    songName: song['song_title'],
                                    lyrics: song['lyrics'],
                                    songNumber: song['song_number'],
                                    favouriteSongs: widget.favoriteSongs,
                                    playlistSongs: [],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
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
                                        '${song['song_number']}',
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
                                      song['song_title'],
                                      style: GoogleFonts.montserrat(fontSize: 18),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        widget.onRemoveFavorite(song['song_title']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: 72,
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
                        initialFavorites: widget.favoriteSongs,
                      ),
                    ),
                  );
                },
                child: _buildNavButton(Icons.music_note, 'Songs'),
              ),
              InkWell(
                onTap: () {
                  // Already on favorites screen
                },
                child: _buildNavButton(Icons.favorite, 'Favorites'),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoriesScreen(
                        favoriteSongs: widget.favoriteSongs,
                        songs: widget.songs,
                        onToggleFavorite: widget.onRemoveFavorite,
                      ),
                    ),
                  );
                },
                child: _buildNavButton(Icons.category, 'Categories'),
              ),
            ],
          ),
        ),
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