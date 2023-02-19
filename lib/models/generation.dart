import 'dart:math';

import 'package:bagarre/game/entities/entity_player.dart';
import 'package:bagarre/models/fight.dart';
import 'package:bagarre/models/player_dna.dart';
import 'package:bagarre/res/consts.dart';
import 'package:flutter/material.dart';

class Generation {
  final int generationIndex;
  final List<PlayerDNA> population;
  final List<Fight> fights;

  const Generation({
    required this.generationIndex,
    required this.population,
    required this.fights,
  });

  factory Generation.initial() {
    final population = List.generate(
      populationSize,
      (index) => PlayerDNA(
        name: 'Player $index',
        boxerSprite: index % 3,
      ),
    );
    final fights = List.generate(
      populationSize ~/ 2,
      (index) => Fight(
        id: index,
        dnaA: population[index * 2],
        dnaB: population[index * 2 + 1],
      ),
    );

    return Generation(
      generationIndex: 0,
      population: population,
      fights: fights,
    );
  }

  void reportFightEnd(
    Fight fight, {
    required EntityPlayer playerA,
    required EntityPlayer playerB,
  }) {
    fight.dnaA.updateFitness(playerA);
    fight.dnaB.updateFitness(playerB);
    fights[fight.id] = fight.copyWith(isDuelOver: true);
  }

  Generation nextGeneration() {
    // sorted scores
    final sortedDnas = population..sort((a, b) => b.fitness.compareTo(a.fitness));
    debugPrint('Generation $generationIndex');
    for (final dna in sortedDnas.take(min(sortedDnas.length, 10))) {
      debugPrint('    ${dna.name}: ${dna.fitness}');
    }

    final bestPlayerCount = (populationSize * 0.2).round();
    final randomPlayerCount = (populationSize * 0.2).round();

    // best players
    final bestPlayers = sortedDnas.take(bestPlayerCount).toList();

    // new population
    final newPopulation = List.generate(populationSize, (index) {
      if (index < bestPlayerCount) {
        return PlayerDNA(
          name: 'Player $index',
          ann: bestPlayers[index].ann,
          boxerSprite: bestPlayers[index].boxerSprite,
        );
      }
      if (index < bestPlayerCount + randomPlayerCount) {
        return PlayerDNA(name: 'Player $index');
      }

      final parentA = bestPlayers[index % bestPlayerCount];
      final parentB = bestPlayers[(index + 1) % bestPlayerCount];
      return PlayerDNA.fromParents(name: 'Player $index', parentA: parentA, parentB: parentB);
    });

    newPopulation.shuffle();

    // new fights
    final newFights = List.generate(
      populationSize ~/ 2,
      (index) => Fight(
        id: index,
        dnaA: newPopulation[index * 2],
        dnaB: newPopulation[index * 2 + 1],
      ),
    );

    return Generation(
      generationIndex: generationIndex + 1,
      population: newPopulation,
      fights: newFights,
    );
  }

  Generation tournamentNextFights() {
    if (fights.length > 1) {
      final winners = fights
          .map(
            (e) => e.dnaA.fitness >= e.dnaB.fitness ? e.dnaA : e.dnaB,
          )
          .toList();

      final newFights = List.generate(
        winners.length ~/ 2,
        (index) => Fight(
          id: index,
          dnaA: winners[index * 2],
          dnaB: winners[index * 2 + 1],
        ),
      );

      return Generation(
        generationIndex: generationIndex,
        population: population,
        fights: newFights,
      );
    }

    return nextGeneration();
  }
}
