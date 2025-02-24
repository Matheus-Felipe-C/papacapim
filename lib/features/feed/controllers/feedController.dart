import 'package:papacapim/features/auth/models/user.dart';
import 'package:papacapim/features/feed/models/post.dart';

class FeedController{
  final List<Post> _posts = [];
  

  List<Post> get posts => List.unmodifiable(_posts);

  void addPost(String message, User user) {
    _posts.insert(0, Post(message: message, user: user));
  }
}

// Cria uma instância global do Feed Controller
final feedController = FeedController();