import 'package:flutter/material.dart';

class IterationModeSelector extends StatelessWidget {
  final IterationMode selected;
  final ValueChanged<IterationMode> onSelectionChanged;

  const IterationModeSelector({
    super.key,
    required this.selected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: const [
        ButtonSegment(value: IterationMode.tournament, label: Text('Mode tournoi')),
        ButtonSegment(value: IterationMode.classic, label: Text('Mode itératif')),
      ],
      selected: {selected},
      multiSelectionEnabled: false,
      onSelectionChanged: (selection) {
        onSelectionChanged(selection.first);
      },
    );
  }
}

enum IterationMode {
  classic,
  tournament,
}
