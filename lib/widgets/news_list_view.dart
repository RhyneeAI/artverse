import 'package:artverse/screens/news_detail_screen.dart';
import 'package:artverse/utils/categories_icon.dart';
import 'package:artverse/utils/date.dart';
import 'package:artverse/utils/constants.dart';
import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'package:shimmer/shimmer.dart';

class NewsListView extends StatelessWidget {
  final List<NewsModel>? newsList;
  final bool isLoading;

  const NewsListView({
    super.key,
    this.newsList,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final showSkeleton = isLoading || newsList == null;
    
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: showSkeleton ? 5 : newsList!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        if (showSkeleton) {
          return _buildSkeletonItem(context);
        }
        return _buildNewsItem(context, newsList![index]);
      }
    );
  }

  Widget _buildSkeletonItem(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Skeleton thumbnail
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skeleton category
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 80,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Skeleton title line 1
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Skeleton title line 2
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 150,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Skeleton source & time
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsItem(BuildContext context, NewsModel news) {
    final isNew = news.createdAt != null 
        ? DateTime.now().difference(news.createdAt!).inDays <= 7
        : false;
    String limitText(String text, {int maxLength = 10}) {
      if (text.length <= maxLength) return text;
      return '${text.substring(0, maxLength)}...';
    }

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
            child: Image.network(
              news.newsImageUrl.toString(), 
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
                Row(
                  children: [
                    Icon(CategoryUtils.getIcon(news.category!.icon ?? 'category'), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      news.category!.name.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  news.title.toString(), 
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      isNew 
                          ? Icons.new_releases_outlined 
                          : Icons.line_style_rounded,
                      size: 16,
                      color: AppColors.accent2,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      limitText(news.source.toString(), maxLength: 11),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.access_time,
                      size: 14, 
                      color: Colors.grey
                    ),
                    const SizedBox(width: 4),
                    Text(
                      (news.createdAt != null) ? DateUtilz.timeAgo(news.createdAt!) : '-',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}