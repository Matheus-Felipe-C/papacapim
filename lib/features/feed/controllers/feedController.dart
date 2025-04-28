import 'package:flutter/material.dart';
import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/feed/models/post.dart';

class FeedController extends ChangeNotifier {
  List<Post> posts = [];
  String? error;
  bool isLoading = false;

  Future<void> loadPosts(String token) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      posts = await ApiService().listPosts(token: token);

    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Adiciona um novo post à lista
  Future<void> addPost(String message, String token) async {
    try {
      await ApiService().createPost(token, message);
      print("Post criado");
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }
  }

  // Alterna entre curtir e descurtir um post
  void toggleLike(Post post) {
    final postIndex = posts.indexOf(post);
    if (postIndex != -1) {
      if (posts[postIndex].isLikedByCurrentUser) {
        posts[postIndex].likes--;
        posts[postIndex].isLikedByCurrentUser = false;
      } else {
        posts[postIndex].likes++;
        posts[postIndex].isLikedByCurrentUser = true;
      }
    }
  }
}

final feedController = FeedController();