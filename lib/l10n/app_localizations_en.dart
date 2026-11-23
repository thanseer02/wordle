// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get wordleTitle => 'WORDLE';

  @override
  String get howToPlay => 'HOW TO PLAY';

  @override
  String get howToPlayDescription =>
      'Guess the WORDLE in 6 tries.\n\n• Each guess must be a valid 5-letter word.\n• The color of the tiles will change to show how close your guess was to the word.';

  @override
  String get correctSpotHint => 'is in the word and in the correct spot.';

  @override
  String get wrongSpotHint => 'is in the word but in the wrong spot.';

  @override
  String get notInWordHint => 'is not in the word in any spot.';

  @override
  String get gotIt => 'GOT IT';

  @override
  String get settings => 'SETTINGS';

  @override
  String get hardMode => 'Hard Mode';

  @override
  String get hardModeSubtitle =>
      'Any revealed hints must be used in subsequent guesses';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get close => 'CLOSE';

  @override
  String get restartGame => 'Restart Game';

  @override
  String get playAgain => 'PLAY AGAIN';

  @override
  String get splendid => 'Splendid!';

  @override
  String get gameOver => 'Game Over';

  @override
  String get enter => 'ENTER';

  @override
  String get notEnoughLetters => 'Not enough letters';

  @override
  String get notInWordList => 'Not in word list';
}
