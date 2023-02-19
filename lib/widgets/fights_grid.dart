import 'package:bagarre/game/game.dart';
import 'package:bagarre/models/fight.dart';
import 'package:bagarre/widgets/fight_widget.dart';
import 'package:flutter/material.dart';

class FightsGrid extends StatelessWidget {
  final List<Fight> fights;
  final void Function(Fight fight, BagarreGame game) onFightEnd;

  const FightsGrid({
    super.key,
    required this.fights,
    required this.onFightEnd,
  });

  @override
  Widget build(BuildContext context) {
    final gridChildrenCount = fights.length;
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    return GridView.count(
      crossAxisCount: _getCrossAxisCount(
        itemsCount: gridChildrenCount,
        aspectRatio: aspectRatio,
        totalWidth: size.width,
        totalHeight: size.height,
      ),
      childAspectRatio: aspectRatio,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      children: [
        for (var i = 0; i < gridChildrenCount; i++)
          FightWidget(fight: fights[i], onFightEnd: (game) => onFightEnd(fights[i], game)),
      ],
    );
  }

  int _getCrossAxisCount({
    required int itemsCount,
    required double aspectRatio,
    required double totalWidth,
    required double totalHeight,
    double verticalSpacing = 10,
  }) {
    var n = 1;
    double neededHeight() {
      var itemHeight = totalWidth / (aspectRatio * n);
      var nbLines = (itemsCount / n).ceil();
      return itemHeight * nbLines + verticalSpacing * (nbLines - 1);
    }

    while (neededHeight() > totalHeight) {
      n++;
    }

    return n;
  }
}
