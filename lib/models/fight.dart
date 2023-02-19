import 'package:bagarre/models/player_dna.dart';

class Fight {
  final int id;

  final PlayerDNA dnaA;
  final PlayerDNA dnaB;
  final bool isDuelOver;

  List<PlayerDNA> get dnas => [dnaA, dnaB];

  const Fight({
    required this.id,
    required this.dnaA,
    required this.dnaB,
    this.isDuelOver = false,
  });

  Fight copyWith({
    int? id,
    PlayerDNA? dnaA,
    PlayerDNA? dnaB,
    bool? isDuelOver,
  }) {
    return Fight(
      id: id ?? this.id,
      dnaA: dnaA ?? this.dnaA,
      dnaB: dnaB ?? this.dnaB,
      isDuelOver: isDuelOver ?? this.isDuelOver,
    );
  }
}
