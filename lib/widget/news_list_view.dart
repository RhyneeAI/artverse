import 'package:artverse/screen/news_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/news_model.dart';

class NewsListView extends StatelessWidget {
  final List<NewsModel> newsList;

  const NewsListView({
    super.key,
    required this.newsList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: newsList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final news = newsList[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewsDetailScreen(news: news),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  news.image,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(news.logo, width: 16),
                        const SizedBox(width: 6),
                        Text(
                          news.source,
                          style:
                              Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          news.timeAgo,
                          style:
                              Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
