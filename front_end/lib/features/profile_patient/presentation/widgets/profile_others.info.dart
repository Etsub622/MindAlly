
import 'package:flutter/material.dart';


class ProfileOthersInfo extends StatelessWidget {
  const ProfileOthersInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: []
      ),
    );
  }
}