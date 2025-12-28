import 'package:artverse/utils/date.dart';
import 'package:flutter/material.dart';
import '../models/news_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({
    super.key,
    required this.news,
  });

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          // 🖼️ Banner image
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            leading: const BackButton(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                news.newsImageUrl.toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 📄 Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Category
                  Text(
                    news.category!.name.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    news.title.toString(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Source & time
                  Row(
                    children: [
                      Icon(Icons.unsubscribe_rounded, size: 12),
                      const SizedBox(width: 8),
                      Text(
                        news.source.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        (news.createdAt != null) ? DateUtilz.timeAgo(news.createdAt!) : '-',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Dummy content
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n'
                    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi '
                    'ut aliquip ex ea commodo consequat.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}