import 'package:flutter/material.dart';

import 'section_header.dart';

/// A titled horizontal rail of cards (poster carousel).
class Carousel extends StatelessWidget {
  const Carousel({
    super.key,
    required this.title,
    required this.children,
    this.actionLabel,
    this.onAction,
    this.itemHeight = 312,
  });

  final String title;
  final List<Widget> children;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title, actionLabel: actionLabel, onAction: onAction),
        const SizedBox(height: 16),
        SizedBox(
          height: itemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: children.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (_, i) => children[i],
          ),
        ),
      ],
    );
  }
}
