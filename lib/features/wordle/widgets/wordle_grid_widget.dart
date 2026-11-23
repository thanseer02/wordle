import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/wordle_model.dart';
import 'wordle_tile_widget.dart';

/// Shake animation widget for an invalid guess row.
class ShakeAnimationWidget extends StatefulWidget {
  final Widget child;
  final AnimationController controller;

  const ShakeAnimationWidget({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<ShakeAnimationWidget> createState() => _ShakeAnimationWidgetState();
}

class _ShakeAnimationWidgetState extends State<ShakeAnimationWidget> {
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value.spMin, 0),
          child: widget.child,
        );
      },
    );
  }
}

/// The 6-row by 5-column Wordle Grid Widget.
/// Sized cleanly with `.spMin` scaling adhering to UI implementation rules.
class WordleGridWidget extends StatelessWidget {
  final List<List<TileModel>> board;
  final int currentRow;
  final AnimationController? activeFlipController;
  final int? flippingRowIndex;
  final AnimationController? activeShakeController;
  final int? shakingRowIndex;
  final int? lastTypedColIndex;

  const WordleGridWidget({
    super.key,
    required this.board,
    required this.currentRow,
    this.activeFlipController,
    this.flippingRowIndex,
    this.activeShakeController,
    this.shakingRowIndex,
    this.lastTypedColIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxGridWidth = min(constraints.maxWidth - 20.spMin, 350.spMin);
        final double maxTileHeight = constraints.maxHeight.isFinite
            ? (constraints.maxHeight / 6.0) - 5.0.spMin
            : 62.0.spMin;
        final double calculatedSize = (maxGridWidth - (4 * 5.0.spMin)) / 5.0;
        final double tileSize = min(calculatedSize, maxTileHeight).clamp(24.0.spMin, 62.0.spMin);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (rowIndex) {
            Widget rowContent = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (colIndex) {
                final tile = board[rowIndex][colIndex];

                Animation<double>? flipAnim;
                if (rowIndex == flippingRowIndex && activeFlipController != null) {
                  final double start = (colIndex * 0.16).clamp(0.0, 0.8);
                  final double end = (start + 0.34).clamp(0.0, 1.0);

                  flipAnim = CurvedAnimation(
                    parent: activeFlipController!,
                    curve: Interval(start, end, curve: Curves.easeInOut),
                  );
                }

                final isCurrentActiveRow = rowIndex == currentRow;
                final shouldPop = isCurrentActiveRow &&
                    colIndex == lastTypedColIndex &&
                    tile.letter.isNotEmpty;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.spMin),
                  child: WordleTileWidget(
                    tile: tile,
                    size: tileSize,
                    animatePop: shouldPop,
                    flipAnimation: flipAnim,
                  ),
                );
              }),
            );

            if (rowIndex == shakingRowIndex && activeShakeController != null) {
              rowContent = ShakeAnimationWidget(
                controller: activeShakeController!,
                child: rowContent,
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.5.spMin),
              child: rowContent,
            );
          }),
        );
      },
    );
  }
}
