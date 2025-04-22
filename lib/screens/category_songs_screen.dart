import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'song_lyrics_screen.dart';
import 'home_screen.dart';
import 'favourites_screen.dart';
import 'categories_screen.dart';

class CategorySongsScreen extends StatefulWidget {
  final String category;
  final List<String> favoriteSongs;
  final List<Map<String, dynamic>> songs;
  final Function(String) onToggleFavorite;

  const CategorySongsScreen({
    super.key,
    required this.category,
    required this.favoriteSongs,
    required this.songs,
    required this.onToggleFavorite,
  });

  @override
  State<CategorySongsScreen> createState() => _CategorySongsScreenState();
}

class _CategorySongsScreenState extends State<CategorySongsScreen> {
  List<Map<String, dynamic>> categorySongs = [];
  bool isLoading = true;
  late List<String> favoriteSongs; // Local copy of favorites

  @override
  void initState() {
    super.initState();
    favoriteSongs = List.from(widget.favoriteSongs);
    _fetchCategorySongs();
  }

  @override
  void didUpdateWidget(CategorySongsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.favoriteSongs != oldWidget.favoriteSongs) {
      favoriteSongs = List.from(widget.favoriteSongs);
    }
  }

  Future<void> _fetchCategorySongs() async {
    try {
      final response = await Supabase.instance.client
          .from('songs')
          .select('song_title, lyrics, category')
          .eq('category', widget.category)
          .order('song_title', ascending: true);

      setState(() {
        categorySongs = List<Map<String, dynamic>>.from(response)
            .asMap()
            .map((index, song) => MapEntry(index, {
                  ...song,
                  'song_number': index + 1,
                }))
            .values
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleFavorite(String songTitle) {
    setState(() {
      if (favoriteSongs.contains(songTitle)) {
        favoriteSongs.remove(songTitle);
      } else {
        favoriteSongs.add(songTitle);
      }
      widget.onToggleFavorite(songTitle); // Notify parent widget
    });
  }

  @override
  Widget build(BuildContext context) {
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
              widget.category,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
  child: isLoading
      ? const Center(child: CircularProgressIndicator())
      : categorySongs.isEmpty
          ? Center(
              child: Text(
                'No ${widget.category} songs found',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchCategorySongs, // your fetch function
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(), // ensures pull works even if list is short
                padding: const EdgeInsets.all(16),
                itemCount: categorySongs.length,
                itemBuilder: (context, index) {
                  final song = categorySongs[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongLyricsScreen(
                            songName: song['song_title'],
                            lyrics: song['lyrics'],
                            songNumber: song['song_number'],
                            favouriteSongs: favoriteSongs,
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
                                  fontSize: 18,
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
                            icon: Icon(
                              favoriteSongs.contains(song['song_title'])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoriteSongs.contains(song['song_title'])
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(song['song_title']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                    songs: widget.songs,
                    onRemoveFavorite: widget.onToggleFavorite,
                  ),
                ),
              );
            },
            child: _buildNavButton(Icons.favorite, 'Favorites'),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoriesScreen(
                    favoriteSongs: favoriteSongs,
                    songs: widget.songs,
                    onToggleFavorite: widget.onToggleFavorite,
                  ),
                ),
              );
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