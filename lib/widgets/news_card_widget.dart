import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String category;
  final String title;
  final String source;
  final String timeAgo;
  final String sourceLogo;
  final String bannerImage;
  final VoidCallback? onTap;
  final double width;

  const NewsCard({
    super.key,
    required this.category,
    required this.title,
    required this.source,
    required this.timeAgo,
    required this.sourceLogo,
    required this.bannerImage,
    this.onTap,
    this.width = 320,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼️ Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                bannerImage,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            // 🏷️ Category
            Text(
              category,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            // 📰 Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // 🧾 Source & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Source
                Row(
                  children: [
                    Image.asset(
                      sourceLogo,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      source,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                // Time
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeAgo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
