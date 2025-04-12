import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SongLyricsScreen extends StatefulWidget {
  final String songName;
  final List<String> favouriteSongs;
  final List<String> playlistSongs;

  const SongLyricsScreen({
    super.key,
    required this.songName,
    required this.favouriteSongs,
    required this.playlistSongs, required int songNumber, required String lyrics,
  });

  @override
  State<SongLyricsScreen> createState() => _SongLyricsScreenState();
}

class _SongLyricsScreenState extends State<SongLyricsScreen> {
  void _addToFavourites() {
    if (!widget.favouriteSongs.contains(widget.songName)) {
      setState(() {
        widget.favouriteSongs.add(widget.songName);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.songName} added to Favourites!',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.songName} is already in Favourites!',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    }
  }

  void _addToPlaylist() {
    if (!widget.playlistSongs.contains(widget.songName)) {
      setState(() {
        widget.playlistSongs.add(widget.songName);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.songName} added to Playlist!',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.songName} is already in Playlist!',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF3498DB),
          title: Text(
            widget.songName,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Lyrics for ${widget.songName} will appear here...',
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF3498DB),
          child: const Icon(Icons.add), // This is the + symbol
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.red),
                      title: Text(
                        'Add to Favourites',
                        style: GoogleFonts.montserrat(),
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the bottom sheet
                        _addToFavourites();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.playlist_add, color: Colors.blue),
                      title: Text(
                        'Add to Playlist',
                        style: GoogleFonts.montserrat(),
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the bottom sheet
                        _addToPlaylist();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}