import 'package:customer/providers/view_model.dart';
import '../model/wordle_model.dart';
import 'package:customer/utils/game_logic.dart';

/// Events dispatched by WordleViewModel to trigger View animations and dialogs.
enum WordleUiEvent {
  invalidLength,
  notInWordList,
  startFlipAnimation,
  gameWon,
  gameLost,
}

/// WordleViewModel extending the project's base [ViewModel].
/// Follows MVVM architecture rules strictly.
class WordleViewModel extends ViewModel {
  // Game state
  late String _targetWord;
  late List<List<TileModel>> _board;
  late Map<String, LetterStatus> _keyboardStatuses;
  int _currentRow = 0;
  int _currentCol = 0;
  int? _lastTypedCol;
  GameStatus _gameStatus = GameStatus.playing;
  bool _isLocked = false;

  void Function(WordleUiEvent event, {String? message})? onUiEvent;

  WordleViewModel() {
    resetGame();
  }

  // Getters
  String get targetWord => _targetWord;
  List<List<TileModel>> get board => _board;
  Map<String, LetterStatus> get keyboardStatuses => _keyboardStatuses;
  int get currentRow => _currentRow;
  int get currentCol => _currentCol;
  int? get lastTypedCol => _lastTypedCol;
  GameStatus get gameStatus => _gameStatus;
  bool get isLocked => _isLocked;

  /// Resets and starts a fresh game.
  void resetGame() {
    _targetWord = GameLogic.pickRandomWord();
    _board = List.generate(
      6,
      (_) => List.generate(5, (_) => const TileModel()),
    );
    _keyboardStatuses = {};
    _currentRow = 0;
    _currentCol = 0;
    _lastTypedCol = null;
    _gameStatus = GameStatus.playing;
    _isLocked = false;
    notifyListeners();
  }

  /// Appends a letter key into the active row.
  void inputKey(String letter) {
    if (_gameStatus != GameStatus.playing || _isLocked) return;

    if (_currentCol < 5) {
      _board[_currentRow][_currentCol] = TileModel(
        letter: letter.toUpperCase(),
        status: LetterStatus.initial,
      );
      _lastTypedCol = _currentCol;
      _currentCol++;
      notifyListeners();
    }
  }

  /// Deletes the last typed letter from the active row.
  void deleteKey() {
    if (_gameStatus != GameStatus.playing || _isLocked) return;

    if (_currentCol > 0) {
      _currentCol--;
      _board[_currentRow][_currentCol] = const TileModel();
      _lastTypedCol = null;
      notifyListeners();
    }
  }

  /// Validates and submits the current guess.
  void submitGuess() {
    if (_gameStatus != GameStatus.playing || _isLocked) return;

    if (_currentCol < 5) {
      onUiEvent?.call(WordleUiEvent.invalidLength);
      return;
    }

    final currentGuess = _board[_currentRow].map((t) => t.letter).join();

    if (!GameLogic.isValidGuess(currentGuess)) {
      onUiEvent?.call(WordleUiEvent.notInWordList);
      return;
    }

    _isLocked = true;
    _lastTypedCol = null;
    notifyListeners();

    onUiEvent?.call(WordleUiEvent.startFlipAnimation);
  }

  /// Called by View once the flip animation completes to finalize evaluated tile states.
  void completeSubmission() {
    final currentGuess = _board[_currentRow].map((t) => t.letter).join();
    final evaluation = GameLogic.evaluateGuess(
      guess: currentGuess,
      target: _targetWord,
    );

    for (int i = 0; i < 5; i++) {
      _board[_currentRow][i] = _board[_currentRow][i].copyWith(
        status: evaluation[i],
      );

      final letter = _board[_currentRow][i].letter;
      final currentKeyStatus = _keyboardStatuses[letter] ?? LetterStatus.initial;
      _keyboardStatuses[letter] = GameLogic.getHigherPriorityStatus(
        currentKeyStatus,
        evaluation[i],
      );
    }

    final isWin = evaluation.every((s) => s == LetterStatus.correctSpot);
    if (isWin) {
      _gameStatus = GameStatus.won;
      _isLocked = false;
      notifyListeners();
      onUiEvent?.call(
        WordleUiEvent.gameWon,
        message: '${_currentRow + 1}',
      );
      return;
    }

    if (_currentRow == 5) {
      _gameStatus = GameStatus.lost;
      _isLocked = false;
      notifyListeners();
      onUiEvent?.call(
        WordleUiEvent.gameLost,
        message: _targetWord,
      );
    } else {
      _currentRow++;
      _currentCol = 0;
      _isLocked = false;
      notifyListeners();
    }
  }
}
