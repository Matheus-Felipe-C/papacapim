import 'package:papacapim/api_service.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/auth/models/session.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:papacapim/features/feed/models/post.dart';

class FeedController {
  List<Post> posts = [];
  final AuthController authController;
  Session? get session => authController.session;

  FeedController({required this.authController});

  // Adiciona um novo post à lista
  void addPost(String message, User user) {
    Post post = await ApiService().createPost(session, message);
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
