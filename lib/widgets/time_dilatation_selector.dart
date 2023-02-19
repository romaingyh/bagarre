import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TimeDilatationSelector extends StatefulWidget {
  const TimeDilatationSelector({super.key});

  @override
  State<TimeDilatationSelector> createState() => _TimeDilatationSelectorState();
}

class _TimeDilatationSelectorState extends State<TimeDilatationSelector> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      multiSelectionEnabled: false,
      segments: const [
        ButtonSegment(value: 1.0, label: Text('1x')),
        ButtonSegment(value: 1 / 3, label: Text('3x')),
        ButtonSegment(value: 1 / 10, label: Text('10x')),
        ButtonSegment(value: 1 / 50, label: Text('50x')),
      ],
      selected: {timeDilation},
      onSelectionChanged: (selection) {
        setState(() {
          timeDilation = selection.first;
        });
      },
    );
  }
}
