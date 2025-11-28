import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePictureWidget extends StatefulWidget {
  final String? imageUrl;
  final String email;
  final double size;
  final bool enableUpload;
  final VoidCallback? onUploadPressed;

  const ProfilePictureWidget({
    super.key,
    this.imageUrl,
    required this.email,
    this.size = 80,
    this.enableUpload = false,
    this.onUploadPressed,
  });

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      print('📸 ProfilePictureWidget initialized with URL: ${widget.imageUrl}');
    } else {
      print('📸 ProfilePictureWidget initialized with no URL (will show default avatar)');
    }
  }

  @override
  void didUpdateWidget(ProfilePictureWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      print('🔄 ProfilePictureWidget URL changed:');
      print('   Old: ${oldWidget.imageUrl ?? "null"}');
      print('   New: ${widget.imageUrl ?? "null"}');

      // If URL changed, evict old image from cache to ensure fresh load
      // Only needed for non-web platforms that use CachedNetworkImage
      if (!kIsWeb && oldWidget.imageUrl != null && oldWidget.imageUrl!.isNotEmpty) {
        CachedNetworkImage.evictFromCache(oldWidget.imageUrl!).then((_) {
          print('✅ Evicted old URL from cache (mobile)');
        }).catchError((error) {
          print('⚠️ Error evicting old URL from cache: $error');
        });
      } else if (kIsWeb) {
        print('ℹ️ Using Image.network on web - no cache eviction needed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Validate that imageUrl is a proper URL
    final hasValidUrl = widget.imageUrl != null &&
        widget.imageUrl!.isNotEmpty &&
        (widget.imageUrl!.startsWith('http://') || widget.imageUrl!.startsWith('https://'));

    return Stack(
      children: [
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
            border: Border.all(
              color: Colors.grey[400]!,
              width: 2,
            ),
          ),
          child: hasValidUrl
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  child: kIsWeb
                      ? Image.network(
                          widget.imageUrl!,
                          key: ValueKey(widget.imageUrl), // Force rebuild when URL changes
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              print('✅ Image.network loaded successfully (web)');
                              return child;
                            }
                            print('⏳ Loading profile picture (web)...');
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: Colors.blue.withValues(alpha: 0.3),
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            print('❌ Image.network failed to load (web):');
                            print('   URL: ${widget.imageUrl}');
                            print('   Error: $error');
                            print('   Falling back to default avatar');
                            return _buildDefaultAvatar();
                          },
                        )
                      : CachedNetworkImage(
                          key: ValueKey(widget.imageUrl), // Force rebuild when URL changes
                          imageUrl: widget.imageUrl!,
                          fit: BoxFit.cover,
                          memCacheHeight: (widget.size * 2).toInt(),
                          memCacheWidth: (widget.size * 2).toInt(),
                          placeholder: (context, url) {
                            print('⏳ Loading profile picture (mobile)...');
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue.withValues(alpha: 0.3),
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            print('❌ CachedNetworkImage failed to load (mobile):');
                            print('   URL: $url');
                            print('   Error: $error');
                            print('   Falling back to default avatar');
                            return _buildDefaultAvatar();
                          },
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 100),
                          httpHeaders: const {
                            'Cache-Control': 'max-age=3600',
                          },
                        ),
                )
              : _buildDefaultAvatar(),
        ),
        if (widget.enableUpload)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: widget.onUploadPressed,
              child: Container(
                width: widget.size * 0.35,
                height: widget.size * 0.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    // Generate avatar initials from email
    final initials = widget.email.isNotEmpty ? widget.email[0].toUpperCase() : '?';

    // Generate a color based on email hash
    final color = _getColorFromEmail(widget.email);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getColorFromEmail(String email) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lime,
      Colors.amber,
      Colors.orange,
    ];

    // Simple hash function to get consistent color for same email
    int hash = email.hashCode.abs();
    return colors[hash % colors.length];
  }
}
