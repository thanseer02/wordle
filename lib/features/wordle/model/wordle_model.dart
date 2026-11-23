import 'package:flutter/material.dart';

/// Represents the status/evaluation of an individual letter or key.
enum LetterStatus {
  initial,
  notInWord,  // Dark Gray
  wrongSpot,  // Yellow
  correctSpot // Green
}

/// Represents the state of a single tile in the grid.
class TileModel {
  final String letter;
  final LetterStatus status;

  const TileModel({
    this.letter = '',
    this.status = LetterStatus.initial,
  });

  TileModel copyWith({
    String? letter,
    LetterStatus? status,
  }) {
    return TileModel(
      letter: letter ?? this.letter,
      status: status ?? this.status,
    );
  }
}

/// Status of the game session.
enum GameStatus {
  playing,
  won,
  lost,
}

/// Wordle game color palette tokens compliant with project styling.
class WordleColors {
  static const Color background = Color(0xFF121213);
  static const Color emptyBorder = Color(0xFF3A3A3C);
  static const Color filledBorder = Color(0xFF565758);
  static const Color keyBackground = Color(0xFF818384);
  
  static const Color correct = Color(0xFF538D4E); // Green
  static const Color wrongPosition = Color(0xFFB59F3B); // Yellow
  static const Color notInWord = Color(0xFF3A3A3C); // Dark Gray
  static const Color textLight = Color(0xFFFFFFFF);
}
