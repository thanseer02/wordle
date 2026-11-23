// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get hello => 'こんにちは';

  @override
  String get wordleTitle => 'WORDLE';

  @override
  String get howToPlay => '遊び方';

  @override
  String get howToPlayDescription =>
      '6回の試行でWORDLEを当ててください。\n\n• 各推測は有効な5文字の単語である必要があります。\n• タイルの色は、推測が単語にどれだけ近かったかを示します。';

  @override
  String get correctSpotHint => 'は単語に含まれており、正しい位置にあります。';

  @override
  String get wrongSpotHint => 'は単語に含まれていますが、位置が違います。';

  @override
  String get notInWordHint => 'は単語のどの位置にも含まれていません。';

  @override
  String get gotIt => '了解';

  @override
  String get settings => '設定';

  @override
  String get hardMode => 'ハードモード';

  @override
  String get hardModeSubtitle => '明かされたヒントは以降の推測で使用する必要があります';

  @override
  String get darkTheme => 'ダークテーマ';

  @override
  String get close => '閉じる';

  @override
  String get restartGame => 'リスタート';

  @override
  String get playAgain => 'もう一度遊ぶ';

  @override
  String get splendid => '素晴らしい！';

  @override
  String get gameOver => 'ゲームオーバー';

  @override
  String get enter => 'ENTER';

  @override
  String get notEnoughLetters => '文字数が足りません';

  @override
  String get notInWordList => '単語リストにありません';
}
