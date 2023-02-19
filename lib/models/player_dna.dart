import 'dart:math';
import 'dart:typed_data';

import 'package:bagarre/game/entities/entity_player.dart';
import 'package:eneural_net/eneural_net.dart';

const int _inputLayerCount = 6;
const int _outputLayerCount = 1;

ANN<double, Float32x4, SignalFloat32x4, Scale<double>> getDefaultANN() => ANN(
      ScaleDouble.ZERO_TO_ONE,
      LayerFloat32x4(_inputLayerCount, false, ActivationFunctionLinear()),
      [],
      LayerFloat32x4(_outputLayerCount, false, ActivationFunctionSigmoid()),
    );

class PlayerDNA {
  final String name;
  final int? boxerSprite;
  late final ANN<double, Float32x4, SignalFloat32x4, Scale<double>> ann;

  double fitness = 0.0;

  PlayerDNA({
    required this.name,
    this.boxerSprite,
    ANN<double, Float32x4, SignalFloat32x4, Scale<double>>? ann,
  }) {
    this.ann = ann ?? getDefaultANN();
  }

  factory PlayerDNA.fromParents({
    required String name,
    required PlayerDNA parentA,
    required PlayerDNA parentB,
  }) {
    final ann = getDefaultANN();

    final weights = ann.allWeights;

    final parentWeights = [parentA.ann.allWeights, parentB.ann.allWeights];
    final random = Random();

    for (var i = 0; i < weights.length; i++) {
      final r = random.nextDouble();

      if (r < 0.4) {
        weights[i] = parentWeights[0][i];
      } else if (r < 0.8) {
        weights[i] = parentWeights[1][i];
      }
    }

    ann.allWeights = weights;

    return PlayerDNA(
      name: name,
      ann: ann,
      boxerSprite: random.nextBool() ? parentA.boxerSprite : parentB.boxerSprite,
    );
  }

  void updateFitness(EntityPlayer player) {
    fitness += player.distanceMoved + player.unStuck;
  }
}
