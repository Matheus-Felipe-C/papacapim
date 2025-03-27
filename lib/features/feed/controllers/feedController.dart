import 'package:papacapim/features/auth/models/user.dart';
import 'package:papacapim/features/feed/models/post.dart';

class FeedController {
  List<Post> posts = [];

  // Adiciona um novo post à lista
  void addPost(String message, User user) {
    posts.add(Post(
      message: message,
      user: user,
    ));
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
