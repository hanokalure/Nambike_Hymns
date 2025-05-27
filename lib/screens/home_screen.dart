import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'song_lyrics_screen.dart';
import 'favourites_screen.dart';
import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<String> initialFavorites;
  
  const HomeScreen({
    super.key, 
    this.initialFavorites = const [],
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> filteredSongs = [];
  List<String> favoriteSongs = [];

  @override
  void initState() {
    super.initState();
    favoriteSongs = List<String>.from(widget.initialFavorites);
    fetchSongs();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> fetchSongs() async {
    final response = await Supabase.instance.client
      .from('songs')
      .select('song_title, lyrics, category')
      .order('song_title', ascending: true);

    setState(() {
      songs = List<Map<String, dynamic>>.from(response)
        .asMap()
        .map((index, song) => MapEntry(index, {
          ...song,
          'song_number': index + 1,
        }))
        .values
        .toList();
      filteredSongs = songs;
    });
  }

  void _onSearchChanged() {
  final query = _searchController.text.toLowerCase();
  setState(() {
    filteredSongs = songs.where((song) {
      // Search both song title and song number
      return song['song_title'].toLowerCase().contains(query) ||
          song['song_number'].toString().contains(query);
    }).toList();
  });
}

  void _toggleFavorite(String songTitle) {
    setState(() {
      if (favoriteSongs.contains(songTitle)) {
        favoriteSongs.remove(songTitle);
      } else {
        favoriteSongs = List.from(favoriteSongs)..add(songTitle);
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About App', style: GoogleFonts.montserrat()),
        content: Text('Nambike Hymns is a simple Christian lyrics app built to glorify God through worship. It provides easy access to heartfelt hymns for personal devotion and praise.',
            style: GoogleFonts.montserrat()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.montserrat()),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  // void _showDeveloperDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('About Developer', style: GoogleFonts.montserrat()),
  //       content: Text(
  //           'contact : hanokalure@gmail.com',
  //           style: GoogleFonts.montserrat()),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('OK', style: GoogleFonts.montserrat()),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 120,
                color: const Color(0xFF3498DB),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 12),
                    child: Text(
                      'Nambike Hymns',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text('About App', style: GoogleFonts.montserrat()),
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog(context);
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.person),
              //   title: Text('About Developer', style: GoogleFonts.montserrat()),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _showDeveloperDialog(context);
              //   },
              // ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              color: const Color(0xFF3498DB),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Color(0xFF3498DB)),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search song here',
                          hintStyle: GoogleFonts.montserrat(color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 11.5),
                        ),
                        style: GoogleFonts.montserrat(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFF3498DB)),
                      onPressed: () {
                        _onSearchChanged();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
  child: RefreshIndicator(
    onRefresh: fetchSongs, // This is your existing fetchSongs method
    child: filteredSongs.isEmpty
        ? Center(
            child: Text('No songs found',
                style: GoogleFonts.montserrat(
                    color: Colors.grey, fontSize: 18)),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredSongs.length,
            itemBuilder: (context, index) {
                        final song = filteredSongs[index];
                        final isFavorite = favoriteSongs.contains(song['song_title']);
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
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey,
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
          ]
        ),
        bottomNavigationBar: Container(
          height: 72,
          color: const Color(0xFF3498DB),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  // Already on home screen
                },
                child: _buildNavButton(Icons.music_note, 'Songs'),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FavouritesScreen(
                        favoriteSongs: List.from(favoriteSongs),
                        songs: songs,
                        onRemoveFavorite: _toggleFavorite,
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
                        favoriteSongs: List.from(favoriteSongs),
                        songs: songs,
                        onToggleFavorite: _toggleFavorite,
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