import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'local_storage_service.dart';

class GalleryService {
  final String baseUrl;
  final LocalStorageService _localStorageService;

  GalleryService(this.baseUrl, this._localStorageService);

  /// Upload design image to the gallery
  Future<Map<String, dynamic>> uploadDesignImage({
    required File imageFile,
    String? notes,
    required String eventId,
  }) async {
    try {
      final token = await _localStorageService.getToken();
      
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('$baseUrl/api/gallery/design')
      );

      // Add authorization header if token exists
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add the image file - use 'images' field name as per API specification
      request.files.add(
        await http.MultipartFile.fromPath(
          'images', 
          imageFile.path,
          filename: imageFile.path.split('/').last,
        )
      );

      // Add form fields as per API specification
      request.fields['event_id'] = eventId;
      if (notes != null && notes.isNotEmpty) {
        request.fields['notes'] = notes;
      }

      print('🚀 Uploading design image to: $baseUrl/api/gallery/design');
      print('🔍 Event ID: $eventId');
      print('🔍 Notes: $notes');
      print('🔍 Token available: ${token != null ? 'Yes' : 'No'}');
      if (token != null) {
        print('🔍 Token preview: ${token.substring(0, 20)}...');
      } else {
        print('⚠️ No authentication token found - upload may fail');
      }
      print('🔍 Form fields: ${request.fields}');
      print('🔍 Files: ${request.files.map((f) => f.field).toList()}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('🔍 Upload response status: ${response.statusCode}');
      final bodyLength = response.body.length;
      final previewLength = bodyLength > 200 ? 200 : bodyLength;
      print('🔍 Upload response body (${bodyLength} chars): ${response.body.substring(0, previewLength)}...');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response is JSON
        if (response.body.trim().startsWith('{') || response.body.trim().startsWith('[')) {
          final responseData = jsonDecode(response.body);
          print('✅ Design image uploaded successfully');
          return {
            'success': true,
            'data': responseData,
            'message': 'Design image uploaded successfully',
          };
        } else {
          print('❌ Upload response is not JSON, got HTML or other format');
          return {
            'success': false,
            'message': 'Server returned non-JSON response. Upload may have failed.',
          };
        }
      } else if (response.statusCode == 404) {
        print('❌ Upload endpoint not found (404)');
        return {
          'success': false,
          'message': 'Upload endpoint not found. The gallery API may not be implemented yet.',
        };
      } else if (response.statusCode == 401) {
        print('❌ Upload unauthorized (401) - Authentication required');
        return {
          'success': false,
          'message': 'Authentication required. Please log in again.',
        };
      } else {
        // Try to parse error response
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to upload design image',
          };
        } catch (jsonError) {
          print('❌ Upload error response is not JSON: ${response.body}');
          return {
            'success': false,
            'message': 'Upload failed (${response.statusCode}): ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}',
          };
        }
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection. Please check your network and try again.',
      };
    } on HttpException {
      return {
        'success': false,
        'message': 'Could not reach the server. Please check if the server is running.',
      };
    } on FormatException {
      return {
        'success': false,
        'message': 'Invalid response from server. Please try again.',
      };
    } catch (e) {
      print('Error uploading design image: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  /// Upload final decoration image to the gallery
  Future<Map<String, dynamic>> uploadFinalDecorationImage({
    required File imageFile,
    String? description,
    required String eventId,
  }) async {
    try {
      final token = await _localStorageService.getToken();
      
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('$baseUrl/api/gallery/final')
      );

      // Add authorization header if token exists
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add the image file - use 'images' field name as per API specification
      request.files.add(
        await http.MultipartFile.fromPath(
          'images', 
          imageFile.path,
          filename: imageFile.path.split('/').last,
        )
      );

      // Add form fields as per API specification
      request.fields['event_id'] = eventId;
      if (description != null && description.isNotEmpty) {
        request.fields['description'] = description;
      }

      print('🚀 Uploading final decoration image to: $baseUrl/api/gallery/final');
      print('🔍 Event ID: $eventId');
      print('🔍 Description: $description');
      print('🔍 Token available: ${token != null ? 'Yes' : 'No'}');
      if (token != null) {
        print('🔍 Token preview: ${token.substring(0, 20)}...');
      } else {
        print('⚠️ No authentication token found - upload may fail');
      }
      print('🔍 Form fields: ${request.fields}');
      print('🔍 Files: ${request.files.map((f) => f.field).toList()}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('🔍 Upload response status: ${response.statusCode}');
      final bodyLength = response.body.length;
      final previewLength = bodyLength > 200 ? 200 : bodyLength;
      print('🔍 Upload response body (${bodyLength} chars): ${response.body.substring(0, previewLength)}...');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response is JSON
        if (response.body.trim().startsWith('{') || response.body.trim().startsWith('[')) {
          final responseData = jsonDecode(response.body);
          print('✅ Final decoration image uploaded successfully');
          return {
            'success': true,
            'data': responseData,
            'message': 'Final decoration image uploaded successfully',
          };
        } else {
          print('❌ Upload response is not JSON, got HTML or other format');
          return {
            'success': false,
            'message': 'Server returned non-JSON response. Upload may have failed.',
          };
        }
      } else if (response.statusCode == 404) {
        print('❌ Upload endpoint not found (404)');
        return {
          'success': false,
          'message': 'Upload endpoint not found. The gallery API may not be implemented yet.',
        };
      } else if (response.statusCode == 401) {
        print('❌ Upload unauthorized (401) - Authentication required');
        return {
          'success': false,
          'message': 'Authentication required. Please log in again.',
        };
      } else {
        // Try to parse error response
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to upload final decoration image',
          };
        } catch (jsonError) {
          print('❌ Upload error response is not JSON: ${response.body}');
          return {
            'success': false,
            'message': 'Upload failed (${response.statusCode}): ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}',
          };
        }
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'No internet connection. Please check your network and try again.',
      };
    } on HttpException {
      return {
        'success': false,
        'message': 'Could not reach the server. Please check if the server is running.',
      };
    } on FormatException {
      return {
        'success': false,
        'message': 'Invalid response from server. Please try again.',
      };
    } catch (e) {
      print('Error uploading final decoration image: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  /// Get design images for an event
  Future<Map<String, dynamic>> getDesignImages(String eventId) async {
    try {
      final token = await _localStorageService.getToken();
      final url = '$baseUrl/api/gallery/design?event_id=$eventId';
      
      print('🔍 Fetching design images from: $url');
      print('🔍 Token available: ${token != null ? 'Yes' : 'No'}');
      if (token != null) {
        print('🔍 Token preview: ${token.substring(0, 20)}...');
      } else {
        print('⚠️ No authentication token found - API calls may fail');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response headers: ${response.headers}');
      final bodyLength = response.body.length;
      final previewLength = bodyLength > 200 ? 200 : bodyLength;
      print('🔍 Response body preview (${bodyLength} chars): ${response.body.substring(0, previewLength)}...');

      if (response.statusCode == 200) {
        // Check if response is JSON
        if (response.body.trim().startsWith('{') || response.body.trim().startsWith('[')) {
          final responseData = jsonDecode(response.body);
          return {
            'success': true,
            'data': responseData,
          };
        } else {
          print('❌ Response is not JSON, got HTML or other format');
          return {
            'success': false,
            'message': 'Server returned non-JSON response. Check API endpoint.',
          };
        }
      } else if (response.statusCode == 404) {
        print('❌ API endpoint not found (404)');
        return {
          'success': false,
          'message': 'API endpoint not found. The gallery API may not be implemented yet.',
        };
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401) - Authentication required');
        return {
          'success': false,
          'message': 'Authentication required. Please log in again.',
        };
      } else {
        // Try to parse error response
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to fetch design images',
          };
        } catch (jsonError) {
          print('❌ Error response is not JSON: ${response.body}');
          return {
            'success': false,
            'message': 'Server error (${response.statusCode}): ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}',
          };
        }
      }
    } catch (e) {
      print('❌ Error fetching design images: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Get event images from the gallery (using the new API endpoint)
  Future<Map<String, dynamic>> getEventImages(String eventId) async {
    try {
      final token = await _localStorageService.getToken();
      final url = '$baseUrl/api/gallery/event/images';
      
      print('🔍 Fetching event images from: $url');
      print('🔍 Event ID: $eventId');
      print('🔍 Token available: ${token != null ? 'Yes' : 'No'}');
      if (token != null) {
        print('🔍 Token preview: ${token.substring(0, 20)}...');
      } else {
        print('⚠️ No authentication token found - API calls may fail');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'event_id': eventId,
        }),
      );

      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response headers: ${response.headers}');
      final bodyLength = response.body.length;
      final previewLength = bodyLength > 200 ? 200 : bodyLength;
      print('🔍 Response body preview (${bodyLength} chars): ${response.body.substring(0, previewLength)}...');

      if (response.statusCode == 200) {
        // Check if response is JSON
        if (response.body.trim().startsWith('{') || response.body.trim().startsWith('[')) {
          final responseData = jsonDecode(response.body);
          return {
            'success': true,
            'data': responseData,
          };
        } else {
          print('❌ Response is not JSON, got HTML or other format');
          return {
            'success': false,
            'message': 'Server returned non-JSON response. Check API endpoint.',
          };
        }
      } else if (response.statusCode == 404) {
        print('❌ API endpoint not found (404)');
        return {
          'success': false,
          'message': 'API endpoint not found. The gallery API may not be implemented yet.',
        };
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401) - Authentication required');
        return {
          'success': false,
          'message': 'Authentication required. Please log in again.',
        };
      } else {
        // Try to parse error response
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to fetch event images',
          };
        } catch (jsonError) {
          print('❌ Error response is not JSON: ${response.body}');
          return {
            'success': false,
            'message': 'Server error (${response.statusCode}): ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}',
          };
        }
      }
    } catch (e) {
      print('❌ Error fetching event images: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Get final decoration images for an event
  Future<Map<String, dynamic>> getFinalDecorationImages(String eventId) async {
    try {
      final token = await _localStorageService.getToken();
      final url = '$baseUrl/api/gallery/final?event_id=$eventId';
      
      print('🔍 Fetching final decoration images from: $url');
      print('🔍 Token available: ${token != null ? 'Yes' : 'No'}');
      if (token != null) {
        print('🔍 Token preview: ${token.substring(0, 20)}...');
      } else {
        print('⚠️ No authentication token found - API calls may fail');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response headers: ${response.headers}');
      final bodyLength = response.body.length;
      final previewLength = bodyLength > 200 ? 200 : bodyLength;
      print('🔍 Response body preview (${bodyLength} chars): ${response.body.substring(0, previewLength)}...');

      if (response.statusCode == 200) {
        // Check if response is JSON
        if (response.body.trim().startsWith('{') || response.body.trim().startsWith('[')) {
          final responseData = jsonDecode(response.body);
          return {
            'success': true,
            'data': responseData,
          };
        } else {
          print('❌ Response is not JSON, got HTML or other format');
          return {
            'success': false,
            'message': 'Server returned non-JSON response. Check API endpoint.',
          };
        }
      } else if (response.statusCode == 404) {
        print('❌ API endpoint not found (404)');
        return {
          'success': false,
          'message': 'API endpoint not found. The gallery API may not be implemented yet.',
        };
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401) - Authentication required');
        return {
          'success': false,
          'message': 'Authentication required. Please log in again.',
        };
      } else {
        // Try to parse error response
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Failed to fetch final decoration images',
          };
        } catch (jsonError) {
          print('❌ Error response is not JSON: ${response.body}');
          return {
            'success': false,
            'message': 'Server error (${response.statusCode}): ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}',
          };
        }
      }
    } catch (e) {
      print('❌ Error fetching final decoration images: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Delete design image
  Future<Map<String, dynamic>> deleteDesignImage(String imageId) async {
    try {
      final token = await _localStorageService.getToken();
      
      final response = await http.delete(
        Uri.parse('$baseUrl/api/gallery/design/$imageId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Image deleted successfully',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to delete image',
        };
      }
    } catch (e) {
      print('Error deleting design image: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred while deleting image.',
      };
    }
  }
}
