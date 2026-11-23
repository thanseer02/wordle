import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:customer/features/wordle/model/wordle_model.dart';
import 'package:customer/features/wordle/view_model/wordle_view_model.dart';
import 'package:customer/features/wordle/view/wordle_screen.dart';
import 'package:customer/utils/game_logic.dart';
import 'package:customer/utils/localization.dart';
import 'package:customer/l10n/app_localizations.dart';

void main() {
  group('GameLogic Unit Tests', () {
    test('Wordle duplicate letter evaluation test', () {
      final result = GameLogic.evaluateGuess(guess: 'ERASE', target: 'SPEED');
      expect(result[0], LetterStatus.wrongSpot);
      expect(result[1], LetterStatus.notInWord);
      expect(result[2], LetterStatus.notInWord);
      expect(result[3], LetterStatus.wrongSpot);
      expect(result[4], LetterStatus.wrongSpot);
    });

    test('Wordle duplicate letters: green takes priority over yellow', () {
      final result = GameLogic.evaluateGuess(guess: 'PUPPY', target: 'APPLE');
      expect(result[0], LetterStatus.wrongSpot);
      expect(result[1], LetterStatus.notInWord);
      expect(result[2], LetterStatus.correctSpot);
      expect(result[3], LetterStatus.notInWord);
      expect(result[4], LetterStatus.notInWord);
    });
  });

  group('WordleViewModel MVVM Tests', () {
    test('Initial ViewModel state is pristine', () {
      final vm = WordleViewModel();
      expect(vm.currentRow, 0);
      expect(vm.currentCol, 0);
      expect(vm.gameStatus, GameStatus.playing);
      expect(vm.board.length, 6);
      expect(vm.board[0].length, 5);
      expect(vm.keyboardStatuses.isEmpty, true);
    });

    test('Inputting keys updates active row and column', () {
      final vm = WordleViewModel();
      vm.inputKey('C');
      vm.inputKey('A');
      vm.inputKey('T');
      expect(vm.currentCol, 3);
      expect(vm.board[0][0].letter, 'C');
      expect(vm.board[0][1].letter, 'A');
      expect(vm.board[0][2].letter, 'T');

      vm.deleteKey();
      expect(vm.currentCol, 2);
      expect(vm.board[0][2].letter, '');
    });

    test('Submitting invalid length triggers UI event', () {
      final vm = WordleViewModel();
      WordleUiEvent? receivedEvent;
      vm.onUiEvent = (event, {message}) {
        receivedEvent = event;
      };
      vm.inputKey('A');
      vm.submitGuess();
      expect(receivedEvent, WordleUiEvent.invalidLength);
    });
  });

  testWidgets('WordleScreen MVVM Widget Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => WordleViewModel(),
        child: ScreenUtilInit(
          designSize: const Size(428, 926),
          builder: (context, child) => MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            builder: (context, child) {
              Localization.init(context);
              return child!;
            },
            home: const WordleScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('WORDLE'), findsOneWidget);
    expect(find.text('ENTER'), findsOneWidget);
  });
}
