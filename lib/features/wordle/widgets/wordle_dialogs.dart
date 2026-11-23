import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:customer/utils/localization.dart';
import 'package:customer/utils/styles.dart';
import '../model/wordle_model.dart';

/// Dialog helper for Wordle game modals (How-to-play, Settings, Game-over).
class WordleDialogs {
  static void showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: WordleColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.spMin),
            side: const BorderSide(color: WordleColors.emptyBorder),
          ),
          title: Text(
            Localization.locale.howToPlay,
            style: tsS18W600.copyWith(
              color: WordleColors.textLight,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Localization.locale.howToPlayDescription,
                style: tsS14W400.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 16.spMin),
              const Divider(color: WordleColors.emptyBorder),
              SizedBox(height: 12.spMin),
              _buildHelpRow('W', WordleColors.correct, Localization.locale.correctSpotHint),
              SizedBox(height: 8.spMin),
              _buildHelpRow('I', WordleColors.wrongPosition, Localization.locale.wrongSpotHint),
              SizedBox(height: 8.spMin),
              _buildHelpRow('U', WordleColors.notInWord, Localization.locale.notInWordHint),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  Localization.locale.gotIt,
                  style: tsS15W700.copyWith(color: WordleColors.correct),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildHelpRow(String letter, Color color, String description) {
    return Row(
      children: [
        Container(
          width: 32.spMin,
          height: 32.spMin,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.spMin),
          ),
          child: Text(
            letter,
            style: tsS15W700.copyWith(color: Colors.white),
          ),
        ),
        SizedBox(width: 12.spMin),
        Expanded(
          child: Text(
            description,
            style: tsS13W600.copyWith(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  static void showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: WordleColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.spMin),
            side: const BorderSide(color: WordleColors.emptyBorder),
          ),
          title: Text(
            Localization.locale.settings,
            style: tsS18W600.copyWith(
              color: WordleColors.textLight,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  Localization.locale.hardMode,
                  style: tsS14W600.copyWith(color: WordleColors.textLight),
                ),
                subtitle: Text(
                  Localization.locale.hardModeSubtitle,
                  style: tsS12W400.copyWith(color: Colors.white54),
                ),
                trailing: Switch(
                  value: false,
                  activeThumbColor: WordleColors.correct,
                  onChanged: (val) {},
                ),
              ),
              const Divider(color: WordleColors.emptyBorder),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  Localization.locale.darkTheme,
                  style: tsS14W600.copyWith(color: WordleColors.textLight),
                ),
                trailing: Switch(
                  value: true,
                  activeThumbColor: WordleColors.correct,
                  onChanged: (val) {},
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  Localization.locale.close,
                  style: tsS15W700.copyWith(color: WordleColors.correct),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showGameOver({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onPlayAgain,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogCtx) {
          return AlertDialog(
            backgroundColor: WordleColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.spMin),
              side: const BorderSide(color: WordleColors.emptyBorder),
            ),
            title: Text(
              title,
              style: tsS18W600.copyWith(
                color: WordleColors.textLight,
                letterSpacing: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: tsS15W500.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.spMin),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WordleColors.correct,
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.spMin,
                      vertical: 12.spMin,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.spMin),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogCtx).pop();
                    onPlayAgain();
                  },
                  child: Text(
                    Localization.locale.playAgain,
                    style: tsS15W700.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
