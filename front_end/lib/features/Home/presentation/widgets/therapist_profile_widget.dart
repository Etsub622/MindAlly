import 'package:flutter/material.dart';
import 'package:front_end/core/utils/constants.dart';
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';
import 'package:go_router/go_router.dart';

class TherapistProfileWidget extends StatefulWidget {
  final UpdateTherapistEntity therapist;
  final BuildContext upperContext;
  final bool isCompact;

  const TherapistProfileWidget({
    super.key,
    required this.upperContext,
    required this.therapist,
    this.isCompact = false,
  });

  @override
  State<TherapistProfileWidget> createState() => _TherapistProfileWidgetState();
}

class _TherapistProfileWidgetState extends State<TherapistProfileWidget> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: InkWell(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) => setState(() => _isTapped = false),
        onTapCancel: () => setState(() => _isTapped = false),
        onTap: () {
          GoRouter.of(widget.upperContext).pushNamed(
            'therapistDetails',
            extra: widget.therapist,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedScale(
          scale: _isTapped ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: widget.isCompact
                ? const EdgeInsets.symmetric(horizontal: 4, vertical: 4)
                : const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Color.fromARGB(255, 249, 246, 251),
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColor.hexToColor("#E6F0FA"), width: 1),
              ),
              child: widget.isCompact
                  ? _buildCompactLayout(context)
                  : _buildDetailedLayout(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints:
            const BoxConstraints(maxWidth: 140, minHeight: 160, maxHeight: 160),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'therapist_${widget.therapist.id ?? 'unknown'}',
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColor.hexToColor("#181C21"),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.therapist.profilePicture ??
                        "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
                  ),
                  backgroundColor: AppColor.hexToColor("#73777F"),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Column(
              children: [
                Text(
                  widget.therapist.name ?? "Unknown",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.hexToColor("#181C21"),
                        fontSize: 14,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.therapist.modality ?? "Not specified",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColor.hexToColor("#73777F"),
                        fontSize: 12,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.therapist.experienceYears ?? 0} yrs",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColor.hexToColor("#73777F"),
                        fontSize: 12,
                      ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'therapist_${widget.therapist.id ?? 'unknown'}',
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColor.hexToColor("#181C21"),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      widget.therapist.profilePicture ??
                          "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
                    ),
                    backgroundColor: AppColor.hexToColor("#73777F"),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.therapist.name ?? "Unknown",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.hexToColor("#181C21"),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.therapist.modality ?? "Not specified",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColor.hexToColor("#73777F"),
                          ),
                    ),
                    Text(
                      "${widget.therapist.experienceYears ?? 0} Years of Experience",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColor.hexToColor("#73777F"),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.therapist.bio ?? "No bio available",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColor.hexToColor("#73777F"),
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       widget.therapist.fee != null ? "\$${widget.therapist.fee}" : "N/A",
          //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //             fontWeight: FontWeight.bold,
          //             color: AppColor.hexToColor("#00538C"),
          //           ),
          //     ),

          //   ],
          // ),
        ],
      ),
    );
  }
}
