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
            widget.songName,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.lyrics
                .split('\n')
                .map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    child: Text(
                      line,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 22,
                        height: 1.3,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}