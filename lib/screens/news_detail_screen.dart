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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Text(
                        news.category!.name.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      SizedBox(height: 8),
                      
                      // Title 
                      Text(
                        news.title.toString(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3, 
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Source
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.source_rounded, size: 16),
                              SizedBox(width: 8),
                              Text(
                                news.source.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          // Author
                          Row(
                            children: [
                              Icon(Icons.people_alt_rounded, size: 16),
                              SizedBox(width: 8),
                              Text(
                                news.author!.full_name ?? "-",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          // Time
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16),
                              SizedBox(width: 8),
                              Text(
                                DateUtilz.timeAgo(news.createdAt!),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Dummy content
                  Text(
                    news.description.toString(),
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