import 'dart:async';
import 'dart:math';

import 'package:bagarre/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EntityPlayer extends SpriteAnimationGroupComponent<EntityPlayerState>
    with HasGameRef<BagarreGame>, CollisionCallbacks {
  final String name;
  final double speed;
  final double maxHealth;
  final int punchSpeed;
  final Direction lookingDirection;
  final int? boxerSprite;

  double get _playerHeight => game.size.y * 0.2;

  EntityPlayer({
    required this.name,
    this.lookingDirection = Direction.left,
    this.speed = 200.0,
    this.maxHealth = 20,
    this.punchSpeed = 400,
    this.boxerSprite,
  });

  late ValueNotifier<double> health = ValueNotifier(maxHealth);

  EntityPlayerState state = EntityPlayerState.idle;

  DateTime lastMove = DateTime.now();
  Vector2 lastPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();

  bool canPunch = true;
  bool isStuckLeft = false;
  bool isStuckRight = false;
  bool get isStuck => isStuckLeft || isStuckRight;

  double distanceMoved = 0;
  int punchsLanded = 0;
  int punchsMissed = 0;
  int punchsBlocked = 0;
  int unStuck = 0;

  EntityPlayer get opponent => game.children.firstWhere(
        (e) => e is EntityPlayer && e != this,
      ) as EntityPlayer;

  @override
  FutureOr<void> onLoad() async {
    await _loadSprites();
    anchor = Anchor.bottomRight;
    size = Vector2(_playerHeight * 0.734, _playerHeight);

    if (lookingDirection == Direction.right) {
      flipHorizontallyAroundCenter();
    }

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (velocity.x == 0 &&
        state != EntityPlayerState.blocking &&
        state != EntityPlayerState.punching) {
      state = EntityPlayerState.idle;
    }

    current = state;

    if (velocity != Vector2.zero()) {
      final normalizedSpeed = speed * game.size.x / 1000;
      final targetPosition = position + velocity * normalizedSpeed * dt;

      final wasStuck = isStuck;

      isStuckLeft = false;
      isStuckRight = false;
      if (lookingDirection == Direction.left) {
        if (targetPosition.x <= opponent.center.x + width) {
          isStuckLeft = true;
        }
        if (targetPosition.x >= game.size.x) {
          isStuckRight = true;
        }
        targetPosition.x = max(opponent.center.x + width, min(targetPosition.x, game.size.x));
      } else {
        if (targetPosition.x <= 0) {
          isStuckLeft = true;
        } else if (targetPosition.x >= opponent.center.x - width) {
          isStuckRight = true;
        }
        targetPosition.x = max(0, min(targetPosition.x, opponent.center.x - width));
      }

      if (wasStuck && !isStuck) {
        unStuck++;
      }
      distanceMoved += position.distanceTo(targetPosition) / game.size.x;

      lastPosition = position;
      position = targetPosition;

      lastMove = DateTime.now();
    }

    super.update(dt);
  }

  void move(Direction direction) {
    if (state != EntityPlayerState.punching) {
      velocity.x = direction.value;

      if (direction == lookingDirection) {
        state = EntityPlayerState.walkingForward;
      } else {
        state = EntityPlayerState.walkingBackward;
      }
    }
  }

  void hit() {
    if (canPunch) {
      canPunch = false;
      state = EntityPlayerState.punching;

      if (collidingWith(opponent)) {
        if (opponent.state != EntityPlayerState.blocking) {
          opponent.damage(1);
        }
      }

      Future.delayed(Duration(milliseconds: punchSpeed), () {
        size.x = _playerHeight * 0.734;
        canPunch = true;
        state = EntityPlayerState.idle;
      });
    }
  }

  void block() {
    if (state != EntityPlayerState.punching) {
      velocity.x = 0;
      state = EntityPlayerState.blocking;
    }
  }

  double damage(double damages) {
    health.value = max(0, health.value - damages);
    if (health.value <= 0) {
      game.endFight();
    }
    return health.value;
  }

  Future _loadSprites() async {
    // from 1 to 3
    final boxerId = (boxerSprite ?? game.random.nextInt(2)) + 1;

    animations = <EntityPlayerState, SpriteAnimation>{
      EntityPlayerState.idle: SpriteAnimation.spriteList(
        await Future.wait(
          List.generate(
            10,
            (i) => Sprite.load('Boxer0$boxerId/1-Idle/__Boxer${boxerId}_Idle_00$i.png'),
          ),
        ),
        stepTime: 0.1,
      ),
      EntityPlayerState.walkingForward: SpriteAnimation.spriteList(
        await Future.wait(
          List.generate(
            10,
            (i) =>
                Sprite.load('Boxer0$boxerId/2-Walk/1-Forward/__Boxer${boxerId}_Forward_00$i.png'),
          ),
        ),
        stepTime: 0.1,
      ),
      EntityPlayerState.walkingBackward: SpriteAnimation.spriteList(
        await Future.wait(
          List.generate(
            10,
            (i) =>
                Sprite.load('Boxer0$boxerId/2-Walk/2-Backward/__Boxer${boxerId}_Backward_00$i.png'),
          ),
        ),
        stepTime: 0.1,
      ),
      EntityPlayerState.punching: SpriteAnimation.spriteList(
        await Future.wait(
          List.generate(
            8,
            (i) => Sprite.load(
              'Boxer0$boxerId/3-Punch/1-JabRight/__Boxer${boxerId}_Punch1_00$i.png',
            ),
          ),
        ),
        stepTime: punchSpeed / 1000 / 8,
      )..onFrame = (currentIndex) {
          if ([4, 5, 6].contains(currentIndex)) {
            size.x = _playerHeight * 0.734 * 1.2;
          } else {
            size.x = _playerHeight * 0.734;
          }
        },
      EntityPlayerState.blocking: SpriteAnimation.spriteList(
        await Future.wait(
          List.generate(
            10,
            (i) => Sprite.load(
              'Boxer0$boxerId/4-Block/__Boxer${boxerId}_Block_00$i.png',
            ),
          ),
        ),
        stepTime: 0.1,
      ),
    };
  }
}

enum Direction {
  left,
  right;

  double get value => this == Direction.left ? -1 : 1;
}

enum EntityPlayerState {
  idle,
  walkingForward,
  walkingBackward,
  punching,
  blocking,
}
