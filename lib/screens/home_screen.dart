import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'song_lyrics_screen.dart';
import 'favourites_screen.dart';
import 'playlist_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<String> songs;

  const HomeScreen({
    super.key,
    this.songs = const [
      'Amazing Grace',
      'Be Thou My Vision',
      'Blessed Assurance',
      'Great Is Thy Faithfulness',
      'Holy, Holy, Holy',
      'How Great Thou Art',
      'I Surrender All',
      'In Christ Alone',
      'It Is Well With My Soul',
      'Jesus, Lover of My Soul',
      'Just As I Am',
      'O for a Thousand Tongues to Sing',
      'Prince of Peace',
      'The Old Rugged Cross',
      'What a Friend We Have in Jesus',
      'When I Survey the Wondrous Cross',
    ],
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<String> filteredSongs;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSongs = widget.songs;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredSongs = widget.songs.where((song) {
        return song.toLowerCase().contains(query);
      }).toList();
    });
  }

  String _getLyricsForSong(String songName) {
    return 'Lyrics for $songName will appear here...';
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About App', style: GoogleFonts.montserrat()),
        content: Text(
          'Prince of Peace Songs\nVersion 1.0.0',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.montserrat()),
          ),
        ],
      ),
    );
  }

  void _showDeveloperDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Developer', style: GoogleFonts.montserrat()),
        content: Text(
          'Developed with ❤️ by Hanok Alure\ncontact : hanokalure@gmail.com',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.montserrat()),
          ),
        ],
      ),
    );
  }

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
                      'Prince of Peace Songs',
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
              ListTile(
                leading: const Icon(Icons.person),
                title: Text('About Developer', style: GoogleFonts.montserrat()),
                onTap: () {
                  Navigator.pop(context);
                  _showDeveloperDialog(context);
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // Top Navbar with Search Bar
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
                        FocusScope.of(context).unfocus(); // hide keyboard
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Song List
            Expanded(
              child: filteredSongs.isEmpty
                  ? Center(
                      child: Text(
                        'No songs found',
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredSongs.length,
                      itemBuilder: (context, index) {
                        final originalIndex = widget.songs.indexOf(filteredSongs[index]);
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SongLyricsScreen(
                                  songName: filteredSongs[index],
                                  songNumber: originalIndex + 1,
                                  lyrics: _getLyricsForSong(filteredSongs[index]),
                                  favouriteSongs: [],
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
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3498DB),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${originalIndex + 1}',
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
                                    filteredSongs[index],
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        // Bottom Navigation Bar
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
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: _buildNavButton(Icons.music_note, 'Songs'),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const FavouritesScreen()),
                  );
                },
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
