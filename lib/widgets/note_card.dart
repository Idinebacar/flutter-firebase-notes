import 'package:flutter/material.dart';
import '../core/utils/date_formatter.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;
  final int color;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    required this.color,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color(color);
    final isDarkBackground = backgroundColor.computeLuminance() < 0.5;

    return Card(
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: backgroundColor == const Color(0xFFFFFFFF)
              ? Theme.of(context).dividerColor
              : Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title.isEmpty ? "Untitled" : title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkBackground ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
                    color: isDarkBackground
                        ? Colors.white70
                        : Colors.redAccent.withOpacity(0.7),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkBackground ? Colors.white70 : Colors.black54,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                DateFormatter.formatShortDate(date),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDarkBackground ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
