import 'package:bagarre/models/player_dna.dart';
import 'package:eneural_net/eneural_net.dart';

import 'entity_player.dart';

class AiControlledPlayer extends EntityPlayer {
  final PlayerDNA dna;

  AiControlledPlayer({
    required this.dna,
    super.lookingDirection,
  }) : super(name: dna.name, boxerSprite: dna.boxerSprite);

  @override
  void update(double dt) {
    final signal = SignalFloat32x4.from(
      [
        position.x / game.size.x,
        isStuckLeft ? 1 : 0,
        isStuckRight ? 1 : 0,
        opponent.x / game.size.x,
        position.distanceTo(opponent.position) / game.size.x,
        game.random.nextDouble(),
      ],
    );

    dna.ann.activate(signal);
    final outputs = dna.ann.output;

    if (outputs[0] < 0.3) {
      move(Direction.left);
    } else if (outputs[0] > 0.7) {
      move(Direction.right);
    }

    super.update(dt);
  }
}
