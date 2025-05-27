import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SongLyricsScreen extends StatefulWidget {
  final String songName;
  final int songNumber;
  final String lyrics;
  final List<String> favouriteSongs;
  final List<String> playlistSongs;

  const SongLyricsScreen({
    super.key,
    required this.songName,
    required this.songNumber,
    required this.lyrics,
    required this.favouriteSongs,
    required this.playlistSongs,
  });

  @override
  State<SongLyricsScreen> createState() => _SongLyricsScreenState();
}

class _SongLyricsScreenState extends State<SongLyricsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF3498DB),
          title: Text(
            '${widget.songNumber}. ${widget.songName}', // Display both number and title
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Changed to left align
            children: [
              // Add some spacing
              const SizedBox(height: 16),
              // Display lyrics with proper formatting
              ...widget.lyrics.split('\n').map(
                (line) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    line,
                    textAlign: TextAlign.left, // Changed to left align
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 18, // Slightly smaller font for better readability
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}