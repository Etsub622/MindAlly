import 'package:flutter/material.dart';
import 'package:front_end/features/resource/presentation/screens/article_resource.dart';
import 'package:front_end/features/resource/presentation/screens/book_resource.dart';
import 'package:front_end/features/resource/presentation/screens/video_resource.dart';

class ResourceRoom extends StatefulWidget {
  const ResourceRoom({super.key});

  @override
  State<ResourceRoom> createState() => _ResourceRoomState();
}

class _ResourceRoomState extends State<ResourceRoom> {
  List<bool> isSelected = [true, false, false];

  Widget _getSelectedPage() {
    // Preserved as-is to avoid modifying resource page content
    if (isSelected[0]) {
      return const BookResource();
    } else if (isSelected[1]) {
      return const VideoResource();
    } else {
      return const ArticleResource();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.2),
              theme.colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore Resources',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
          
                  ],
                ),
              ),
              // Toggle Bar
              ResourceToggleBar(
                isSelected: isSelected,
                onToggle: (idx) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == idx;
                    }
                  });
                },
              ),
              // Resource Page
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: Container(
                          key: ValueKey(isSelected.indexOf(true)),
                          child: _getSelectedPage(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourceToggleBar extends StatelessWidget {
  final List<bool> isSelected;
  final Function(int) onToggle;

  const ResourceToggleBar({
    super.key,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Sliding Indicator
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: (size.width - 32) / 3 * isSelected.indexOf(true) + 4,
              top: 4,
              bottom: 4,
              width: (size.width - 32) / 3 - 8,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            // Toggle Items
            Row(
              children: [
                _buildToggleItem(
                  context,
                  index: 0,
                  icon: Icons.book_outlined,
                  label: 'Books',
                  isSelected: isSelected[0],
                ),
                _buildToggleItem(
                  context,
                  index: 1,
                  icon: Icons.play_circle_outline,
                  label: 'Videos',
                  isSelected: isSelected[1],
                ),
                _buildToggleItem(
                  context,
                  index: 2,
                  icon: Icons.article_outlined,
                  label: 'Articles',
                  isSelected: isSelected[2],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => onToggle(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}