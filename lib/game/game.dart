import 'dart:async';
import 'dart:math';

import 'package:bagarre/game/entities/ai_controlled_player.dart';
import 'package:bagarre/game/entities/user_controlled_player.dart';
import 'package:bagarre/models/player_dna.dart';
import 'package:bagarre/res/overlays.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'entities/entity_player.dart';

class BagarreGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  final Random random = Random();

  final int fightDurationS;
  final void Function(BagarreGame game)? onFightEnd;

  late final EntityPlayer playerA;
  late final EntityPlayer playerB;
  late final DateTime fightStartDateTime;

  BagarreGame({
    this.fightDurationS = 30,
    this.onFightEnd,
    List<PlayerDNA> dnas = const [],
  }) {
    if (dnas.isNotEmpty) {
      playerA = AiControlledPlayer(
        dna: dnas[0],
        lookingDirection: Direction.right,
      );
      playerB = AiControlledPlayer(
        dna: dnas[1],
      );
    } else {
      playerA = UserControlledPlayer(
        name: 'Player A',
        lookingDirection: Direction.right,
      );
      playerB = EntityPlayer(
        name: 'Player B',
      );
    }
  }

  double get fightElapsedTimeS =>
      DateTime.now().difference(fightStartDateTime).inMilliseconds / 1000 / timeDilation;

  @override
  Future<void> onLoad() async {
    if (debugMode) {
      add(FpsTextComponent(anchor: Anchor.bottomLeft));
    }

    final ground = GroundComponent();
    await add(ground);

    await add(playerA);
    await add(playerB);

    playerA.position = Vector2(size.x / 3 + playerA.size.x / 2, ground.y);
    playerB.position = Vector2(size.x / 3 * 2 + playerB.size.x / 2, ground.y);

    overlays.add(Overlays.fightOverlay);

    fightStartDateTime = DateTime.now();
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 36, 11, 95);
  }

  @override
  void update(double dt) {
    if (fightElapsedTimeS >= fightDurationS) {
      endFight();
    }
    super.update(dt);
  }

  void endFight() {
    pauseEngine();
    onFightEnd?.call(this);
  }
}

class GroundComponent extends RectangleComponent with HasGameRef<BagarreGame> {
  @override
  FutureOr<void> onLoad() {
    paint = Paint()..color = const Color.fromARGB(255, 0, 42, 255);
    size = Vector2(gameRef.size.x, gameRef.size.y * 0.2);
    position = Vector2(0, gameRef.size.y - size.y);
  }
}
