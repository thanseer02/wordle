import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/wordle_model.dart';
import 'package:customer/utils/styles.dart';

/// QWERTY Keyboard Widget for Wordle.
/// Features exact Wordle flex weights and responsive `.spMin` sizing.
class WordleKeyboardWidget extends StatelessWidget {
  final Map<String, LetterStatus> letterStatuses;
  final ValueChanged<String> onKeyTapped;
  final VoidCallback onDelete;
  final VoidCallback onSubmit;

  const WordleKeyboardWidget({
    super.key,
    required this.letterStatuses,
    required this.onKeyTapped,
    required this.onDelete,
    required this.onSubmit,
  });

  static const List<String> _row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  static const List<String> _row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  static const List<String> _row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  Color _getKeyColor(String key) {
    final status = letterStatuses[key] ?? LetterStatus.initial;
    switch (status) {
      case LetterStatus.correctSpot:
        return WordleColors.correct;
      case LetterStatus.wrongSpot:
        return WordleColors.wrongPosition;
      case LetterStatus.notInWord:
        return WordleColors.notInWord;
      case LetterStatus.initial:
        return WordleColors.keyBackground;
    }
  }

  Widget _buildKeyButton({
    required Widget child,
    required VoidCallback onTap,
    required Color color,
    required int flex,
    required double keyHeight,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0.spMin),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: keyHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0.spMin),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(4.0.spMin),
              splashColor: Colors.white24,
              highlightColor: Colors.white10,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterKey(String letter, double keyHeight) {
    return _buildKeyButton(
      flex: 10,
      keyHeight: keyHeight,
      color: _getKeyColor(letter),
      onTap: () => onKeyTapped(letter),
      child: Text(
        letter,
        style: tsS15W700.copyWith(
          fontSize: 14.5.spMin,
          color: WordleColors.textLight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final keyHeight = screenWidth < 360 ? 48.0.spMin : 56.0.spMin;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500.spMin),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.0.spMin, vertical: 8.0.spMin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row 1: Q W E R T Y U I O P
              Row(
                children: _row1.map((key) => _buildLetterKey(key, keyHeight)).toList(),
              ),
              SizedBox(height: 7.spMin),

              // Row 2: Spacer(5) + A S D F G H J K L + Spacer(5)
              Row(
                children: [
                  const Spacer(flex: 5),
                  ..._row2.map((key) => _buildLetterKey(key, keyHeight)),
                  const Spacer(flex: 5),
                ],
              ),
              SizedBox(height: 7.spMin),

              // Row 3: ENTER + Z X C V B N M + BACKSPACE
              Row(
                children: [
                  _buildKeyButton(
                    flex: 15,
                    keyHeight: keyHeight,
                    color: WordleColors.keyBackground,
                    onTap: onSubmit,
                    child: Text(
                      'ENTER',
                      style: tsS13W600.copyWith(
                        fontSize: 12.0.spMin,
                        color: WordleColors.textLight,
                      ),
                    ),
                  ),
                  ..._row3.map((key) => _buildLetterKey(key, keyHeight)),
                  _buildKeyButton(
                    flex: 15,
                    keyHeight: keyHeight,
                    color: WordleColors.keyBackground,
                    onTap: onDelete,
                    child: Icon(
                      Icons.backspace_outlined,
                      color: WordleColors.textLight,
                      size: 21.spMin,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
