import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimateListWidget extends StatelessWidget {
  const AnimateListWidget({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: AnimateList(
          interval: 30.ms,
          effects: [FadeEffect(duration: 100.ms)],
          children: children,
        ),
      ),
    );
  }
}
