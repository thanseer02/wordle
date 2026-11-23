import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:customer/utils/localization.dart';
import 'package:customer/utils/styles.dart';
import '../model/wordle_model.dart';
import '../view_model/wordle_view_model.dart';
import '../widgets/wordle_grid_widget.dart';
import '../widgets/wordle_keyboard_widget.dart';
import '../widgets/wordle_dialogs.dart';

/// WordleScreen following project architecture rules:
/// - Screen class ends with `Screen`, file ends with `_screen.dart`
/// - Defines `static const String routeName = '/WordleScreen';`
/// - Extracted sub-components into `widgets/`
/// - Localized all string literals via `Localization.locale`
/// - Sizing using `.spMin`
class WordleScreen extends StatefulWidget {
  static const String routeName = '/WordleScreen';

  const WordleScreen({super.key});

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen>
    with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();

  late AnimationController _flipController;
  late AnimationController _shakeController;
  int? _flippingRowIndex;
  int? _shakingRowIndex;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final viewModel = context.read<WordleViewModel>();
        viewModel.onUiEvent = _handleUiEvent;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _flipController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleUiEvent(WordleUiEvent event, {String? message}) async {
    final viewModel = context.read<WordleViewModel>();

    switch (event) {
      case WordleUiEvent.invalidLength:
        _showToast(Localization.locale.notEnoughLetters);
        _triggerShake(viewModel.currentRow);
        break;

      case WordleUiEvent.notInWordList:
        _showToast(Localization.locale.notInWordList);
        _triggerShake(viewModel.currentRow);
        break;

      case WordleUiEvent.startFlipAnimation:
        setState(() {
          _flippingRowIndex = viewModel.currentRow;
        });
        await _flipController.forward(from: 0.0);
        if (mounted) {
          setState(() {
            _flippingRowIndex = null;
          });
          viewModel.completeSubmission();
        }
        break;

      case WordleUiEvent.gameWon:
        WordleDialogs.showGameOver(
          context: context,
          title: Localization.locale.splendid,
          message: 'You guessed the word in $message ${message == "1" ? "attempt" : "attempts"}!',
          onPlayAgain: () => viewModel.resetGame(),
        );
        break;

      case WordleUiEvent.gameLost:
        WordleDialogs.showGameOver(
          context: context,
          title: Localization.locale.gameOver,
          message: 'The word was $message.',
          onPlayAgain: () => viewModel.resetGame(),
        );
        break;
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: tsS14W600.copyWith(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.72,
          left: 60.spMin,
          right: 60.spMin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.spMin),
        ),
      ),
    );
  }

  void _triggerShake(int rowIndex) {
    setState(() {
      _shakingRowIndex = rowIndex;
    });
    _shakeController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _shakingRowIndex = null;
        });
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final viewModel = context.read<WordleViewModel>();

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      viewModel.submitGuess();
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
      viewModel.deleteKey();
      return KeyEventResult.handled;
    } else {
      final keyLabel = event.character?.toUpperCase() ??
          event.logicalKey.keyLabel.toUpperCase();
      if (keyLabel.length == 1 &&
          keyLabel.codeUnitAt(0) >= 65 &&
          keyLabel.codeUnitAt(0) <= 90) {
        viewModel.inputKey(keyLabel);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WordleColors.background,
      appBar: AppBar(
        backgroundColor: WordleColors.background,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: WordleColors.emptyBorder,
            height: 1.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.help_outline, color: WordleColors.textLight),
          onPressed: () => WordleDialogs.showHowToPlay(context),
          tooltip: Localization.locale.howToPlay,
        ),
        title: Text(
          Localization.locale.wordleTitle,
          style: tsS22W600.copyWith(
            color: WordleColors.textLight,
            fontWeight: FontWeight.w900,
            fontSize: 28.spMin,
            letterSpacing: 3.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: WordleColors.textLight),
            onPressed: () => context.read<WordleViewModel>().resetGame(),
            tooltip: Localization.locale.restartGame,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: WordleColors.textLight),
            onPressed: () => WordleDialogs.showSettings(context),
            tooltip: Localization.locale.settings,
          ),
        ],
      ),
      body: SafeArea(
        child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: _handleKeyEvent,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Consumer<WordleViewModel>(
                    builder: (context, vm, child) {
                      return WordleGridWidget(
                        board: vm.board,
                        currentRow: vm.currentRow,
                        activeFlipController: _flipController,
                        flippingRowIndex: _flippingRowIndex,
                        activeShakeController: _shakeController,
                        shakingRowIndex: _shakingRowIndex,
                        lastTypedColIndex: vm.lastTypedCol,
                      );
                    },
                  ),
                ),
              ),
              Consumer<WordleViewModel>(
                builder: (context, vm, child) {
                  return WordleKeyboardWidget(
                    letterStatuses: vm.keyboardStatuses,
                    onKeyTapped: vm.inputKey,
                    onDelete: vm.deleteKey,
                    onSubmit: vm.submitGuess,
                  );
                },
              ),
              SizedBox(height: 8.spMin),
            ],
          ),
        ),
      ),
    );
  }
}
