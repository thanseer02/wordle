import 'dart:math';
import '../features/wordle/model/wordle_model.dart';
import 'word_list.dart';

/// Game logic helper class for Wordle calculations.
class GameLogic {
  /// Picks a random target word from the word list.
  static String pickRandomWord() {
    final random = Random();
    return kTargetWords[random.nextInt(kTargetWords.length)];
  }

  /// Checks if the guessed word is valid (5 letters and exists in dictionary).
  static bool isValidGuess(String word) {
    if (word.length != 5) return false;
    final upper = word.toUpperCase();
    return kValidGuessWords.contains(upper);
  }

  /// Evaluates a 5-letter guess against the target word.
  /// Handles duplicate letters correctly:
  /// 1. Mark Green (correct position) and decrease target letter count.
  /// 2. For remaining letters, mark Yellow if letter is still available in target;
  ///    otherwise mark Gray.
  static List<LetterStatus> evaluateGuess({
    required String guess,
    required String target,
  }) {
    assert(guess.length == 5 && target.length == 5);
    final results = List<LetterStatus>.filled(5, LetterStatus.notInWord);
    final targetChars = target.split('');
    final guessChars = guess.split('');

    // Frequency map of characters in target word
    final Map<String, int> letterCounts = {};
    for (final char in targetChars) {
      letterCounts[char] = (letterCounts[char] ?? 0) + 1;
    }

    // Step 1: Find all greens (exact match)
    for (int i = 0; i < 5; i++) {
      if (guessChars[i] == targetChars[i]) {
        results[i] = LetterStatus.correctSpot;
        letterCounts[guessChars[i]] = letterCounts[guessChars[i]]! - 1;
      }
    }

    // Step 2: Find yellows (wrong position) among non-green spots
    for (int i = 0; i < 5; i++) {
      if (results[i] == LetterStatus.correctSpot) continue;

      final char = guessChars[i];
      if (letterCounts.containsKey(char) && letterCounts[char]! > 0) {
        results[i] = LetterStatus.wrongSpot;
        letterCounts[char] = letterCounts[char]! - 1;
      } else {
        results[i] = LetterStatus.notInWord;
      }
    }

    return results;
  }

  /// Updates the keyboard letter status according to priority:
  /// green (correctSpot) > yellow (wrongSpot) > gray (notInWord) > initial.
  static LetterStatus getHigherPriorityStatus(
    LetterStatus current,
    LetterStatus newStatus,
  ) {
    if (current == LetterStatus.correctSpot) {
      return LetterStatus.correctSpot;
    }
    if (newStatus == LetterStatus.correctSpot) {
      return LetterStatus.correctSpot;
    }
    if (current == LetterStatus.wrongSpot) {
      return LetterStatus.wrongSpot;
    }
    if (newStatus == LetterStatus.wrongSpot) {
      return LetterStatus.wrongSpot;
    }
    if (current == LetterStatus.notInWord) {
      return LetterStatus.notInWord;
    }
    return newStatus;
  }
}
