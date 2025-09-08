import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:io';

import '../../../themes/app_theme.dart';
import '../../../services/gallery_service.dart';

/// Full Screen Image Viewer with Zoom and Gallery Support
class FullScreenImageViewer extends StatefulWidget {
  final String imagePath;
  final int imageIndex;
  final List<Map<String, dynamic>> images;
  final bool isDesignTab;
  final GalleryService? galleryService;
  final Function(int) onDelete;

  const FullScreenImageViewer({
    Key? key,
    required this.imagePath,
    required this.imageIndex,
    required this.images,
    required this.isDesignTab,
    required this.galleryService,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.imageIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Get appropriate image provider based on image path
  ImageProvider _getImageProvider(String imagePath) {
    // Check if it's a network URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    } else {
      // Local file
      return FileImage(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Photo View Gallery
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              final imagePath = widget.images[index]['image_path'] ?? '';
              return PhotoViewGalleryPageOptions(
                imageProvider: _getImageProvider(imagePath),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                heroAttributes: PhotoViewHeroAttributes(tag: "image_$index"),
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade900,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load image',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: widget.images.length,
            loadingBuilder: (context, event) => Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(
                  value: event?.expectedTotalBytes != null
                      ? event!.cumulativeBytesLoaded / event!.expectedTotalBytes!
                      : null,
                  color: AppColors.primary,
                ),
              ),
            ),
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          
          // Top App Bar
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  
                  // Image Counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  // Delete Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.grey.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text(
                              'Delete Image',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'Are you sure you want to delete this image?',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  
                                  // Check if image has API data (was uploaded to server)
                                  final imageData = widget.images[_currentIndex];
                                  if (imageData['api_data'] != null && imageData['api_data']['id'] != null) {
                                    // Show loading indicator
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    );

                                    try {
                                      if (widget.galleryService == null) {
                                        Navigator.of(context).pop(); // Close loading dialog
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Services are still initializing. Please wait a moment and try again.'),
                                            backgroundColor: Colors.orange,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                        return;
                                      }

                                      final result = await widget.galleryService!.deleteDesignImage(
                                        imageData['api_data']['id'].toString(),
                                      );

                                      // Close loading dialog
                                      Navigator.of(context).pop();

                                      if (result['success']) {
                                        // Call the delete callback
                                        widget.onDelete(_currentIndex);
                                        
                                        // Show success message
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Image deleted successfully'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } else {
                                        // Show error message
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(result['message'] ?? 'Failed to delete image'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      // Close loading dialog
                                      Navigator.of(context).pop();
                                      
                                      // Show error message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('An error occurred: ${e.toString()}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } else {
                                    // Image was not uploaded to server, just call delete callback
                                    widget.onDelete(_currentIndex);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Info Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Notes/Description
                  if (widget.images[_currentIndex][widget.isDesignTab ? 'notes' : 'description'] != null &&
                      widget.images[_currentIndex][widget.isDesignTab ? 'notes' : 'description'].toString().isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            widget.isDesignTab ? Icons.note : Icons.description,
                            color: Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.images[_currentIndex][widget.isDesignTab ? 'notes' : 'description'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Navigation Instructions
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pinch to zoom • Swipe to navigate • Long press for options',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
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
