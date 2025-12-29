import 'package:artverse/controllers/auth_controller.dart';
import 'package:artverse/controllers/bookmark_controller.dart';
import 'package:artverse/controllers/news_controller.dart';
import 'package:artverse/models/news_model.dart';
import 'package:artverse/screens/news_detail_screen.dart';
import 'package:artverse/utils/categories_icon.dart';
import 'package:artverse/utils/date.dart';
import 'package:artverse/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsCard extends StatefulWidget {
  final NewsModel? news;
  final bool isLoading;
  
  const NewsCard({super.key, this.news, this.isLoading = false});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool _isBookmarked = false;
  bool _isAnimating = false;
  final BookmarkController _bookmarkController = BookmarkController();
  final NewsController _newsController = NewsController();

  final AuthController _authController = AuthController();

  late NewsModel? _news;

  @override
  void initState() {
    super.initState();
    _news = widget.news;
    _isBookmarked = _news?.isBookmarked ?? false;
  }

  Future<void> _toggleBookmark() async {
    if (_news?.id == null) return;
    
    setState(() => _isAnimating = true);
    
    try {
      final user = await _authController.getCurrentUser();
      if (user?.id == null) {
        SnackbarUtils.showError(context, 'Please login first');
        return;
      }
      
      final newState = await _bookmarkController.addBookmark(
        _news!.id!,
        user!.id!, 
      );
      
      setState(() {
        _isBookmarked = newState;
        _isAnimating = false;
      });
    } catch (e) {
      setState(() => _isAnimating = false);
      SnackbarUtils.showError(context, 'Failed: $e');
    }
  }

  bool isNew() {
     if (_news!.createdAt == null) return false;
      return DateTime.now().difference(_news!.createdAt!).inDays <= 7;
  }

  String timeAgoOrEmpty(DateTime? date) {
    if (date == null) return '';
    return DateUtilz.timeAgo(date);
  }

  String limitText(String text, {int maxLength = 10}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading || _news == null) {
      return _buildSkeleton(context);
    }
    return _buildNewsCard(context);
  }

  Widget _buildSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton image
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            // Skeleton category
            Container(
              width: 60,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            // Skeleton title line 1
            Container(
              width: double.infinity,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            // Skeleton title line 2
            Container(
              width: 150,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context) {
    return SizedBox(
      width: 250,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await _newsController.incrementVisitCount(_news!.id.toString());
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetailScreen(news: _news!),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Banner Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _news!.newsImageUrl.toString(),
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleBookmark,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      child: _isAnimating
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Icon(
                              _isBookmarked 
                                  ? Icons.bookmark 
                                  : Icons.bookmark_border,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🏷️ Category
            Text(
              _news!.category!.name.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            // 📰 Title
            Text(
              _news!.title.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // 🧾 Author & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Author
                Row(
                  children: [
                    Icon(isNew() ? Icons.new_releases_outlined : Icons.line_style_rounded),
                    const SizedBox(width: 8),
                    Icon(CategoryUtils.getIcon(_news!.category!.icon.toString())),
                    const SizedBox(width: 8),
                    Text(
                      limitText(_news!.source.toString(), maxLength: 11),
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
                      timeAgoOrEmpty(_news!.createdAt),
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
