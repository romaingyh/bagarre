import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'entity_player.dart';

class UserControlledPlayer extends EntityPlayer with KeyboardHandler {
  UserControlledPlayer({required super.name, super.lookingDirection});

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    velocity.x = 0;

    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.space)) {
        hit();
      }

      if (keysPressed.contains(LogicalKeyboardKey.keyB)) {
        block();
      }

      if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        move(Direction.right);
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        move(Direction.left);
      }
    }

    return true;
  }
}
