import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/wordle_model.dart';
import 'package:customer/utils/styles.dart';

/// Individual Wordle Letter Tile Widget.
/// Follows naming convention ending with `Widget` and uses `.spMin` sizing.
class WordleTileWidget extends StatefulWidget {
  final TileModel tile;
  final double size;
  final bool animatePop;
  final Animation<double>? flipAnimation;

  const WordleTileWidget({
    super.key,
    required this.tile,
    required this.size,
    this.animatePop = false,
    this.flipAnimation,
  });

  @override
  State<WordleTileWidget> createState() => _WordleTileWidgetState();
}

class _WordleTileWidgetState extends State<WordleTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _popController;
  late Animation<double> _popAnimation;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _popAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_popController);

    if (widget.animatePop && widget.tile.letter.isNotEmpty) {
      _popController.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant WordleTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animatePop &&
        widget.tile.letter.isNotEmpty &&
        oldWidget.tile.letter != widget.tile.letter) {
      _popController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(LetterStatus status) {
    switch (status) {
      case LetterStatus.correctSpot:
        return WordleColors.correct;
      case LetterStatus.wrongSpot:
        return WordleColors.wrongPosition;
      case LetterStatus.notInWord:
        return WordleColors.notInWord;
      case LetterStatus.initial:
        return WordleColors.background;
    }
  }

  Border _getBorder(LetterStatus status, bool hasLetter) {
    if (status != LetterStatus.initial) {
      return Border.all(color: Colors.transparent, width: 2.spMin);
    }
    return Border.all(
      color: hasLetter ? WordleColors.filledBorder : WordleColors.emptyBorder,
      width: 2.spMin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLetter = widget.tile.letter.isNotEmpty;

    Widget buildTileBody({
      required Color bgColor,
      required Border border,
      required String letter,
    }) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4.spMin),
          border: border,
        ),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: tsS22W600.copyWith(
            fontSize: (widget.size * 0.52).spMin,
            color: WordleColors.textLight,
          ),
        ),
      );
    }

    Widget content;
    if (widget.flipAnimation != null) {
      content = AnimatedBuilder(
        animation: widget.flipAnimation!,
        builder: (context, child) {
          final value = widget.flipAnimation!.value;
          final angle = value * pi;
          final isPastHalfway = angle >= (pi / 2);

          final currentBg = isPastHalfway
              ? _getBackgroundColor(widget.tile.status)
              : WordleColors.background;
          final currentBorder = isPastHalfway
              ? Border.all(color: Colors.transparent, width: 2.spMin)
              : _getBorder(LetterStatus.initial, hasLetter);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateX(angle),
            child: isPastHalfway
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateX(pi),
                    child: buildTileBody(
                      bgColor: currentBg,
                      border: currentBorder,
                      letter: widget.tile.letter,
                    ),
                  )
                : buildTileBody(
                    bgColor: currentBg,
                    border: currentBorder,
                    letter: widget.tile.letter,
                  ),
          );
        },
      );
    } else {
      content = buildTileBody(
        bgColor: _getBackgroundColor(widget.tile.status),
        border: _getBorder(widget.tile.status, hasLetter),
        letter: widget.tile.letter,
      );
    }

    return ScaleTransition(
      scale: _popAnimation,
      child: content,
    );
  }
}
