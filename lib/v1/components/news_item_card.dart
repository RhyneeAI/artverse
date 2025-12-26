import 'package:flutter/material.dart';
import 'package:artverse/v1/utils/constants.dart';
import 'package:artverse/models/news_model.dart';

class NewsItemCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;

  const NewsItemCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar thumbnail (jika ada)
            if (article.imageUrl != null)
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(article.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge kategori + negara
                  Row(
                    children: [
                      _buildCategoryBadge(),
                      const SizedBox(width: 8),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Judul
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Deskripsi
                  if (article.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  // Sumber dan waktu
                  const SizedBox(height: 12),
                  _buildSourceInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        article.category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSourceInfo() {
  return Row(
    children: [
      Expanded( // Wrap dengan Expanded
        flex: 5, // Beri flex lebih besar untuk source
        child: Text(
          article.source,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1, // Batasi 1 baris
          overflow: TextOverflow.ellipsis, // Tambahkan "..."
        ),
      ),
      const SizedBox(width: 8),
      if (article.isPremium)
        Icon(
          Icons.monetization_on_outlined,
          size: 16,
          color: AppColors.textSecondary,
        ),
      const SizedBox(width: 8),
      Icon(
        Icons.alarm,
        size: 12,
        color: AppColors.textSecondary,
      ),
      const SizedBox(width: 4),
      Expanded(
        flex: 1, // Flex lebih kecil untuk waktu
        child: Text(
          article.time,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    ],
  );
}
}