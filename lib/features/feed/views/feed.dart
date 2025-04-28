import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/feed/controllers/feedController.dart';
import 'package:papacapim/features/feed/views/newPostScreen.dart';
import 'package:papacapim/features/feed/views/postCard.dart';
import 'package:papacapim/features/feed/views/PostDetailScreen.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final feed = context.read<FeedController>();

      if (feed.posts.isEmpty && feed.error == null) {
        await _loadPosts();
      }
    });
  }

  Future<void> _loadPosts() async {
    final feed = context.read<FeedController>();
    final auth = context.read<AuthController>();

    await feed.loadPosts(auth.token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ),
      body: Consumer<FeedController>(
        builder: (context, feed, child) {
          if (feed.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(feed.error!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadPosts,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (feed.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Carregando posts..."),
                ],
              ),
            );
          }

          if (feed.posts.isEmpty) {
            return const Center(child: Text("Nenhum post encontrado."));
          }

          return RefreshIndicator(
            onRefresh: _loadPosts,
            child: ListView.builder(
              itemCount: feed.posts.length,
              itemBuilder: (context, index) {
                final post = feed.posts[index];
                return PostCard(
                  message: post.message,
                  username: '',
                  likes: post.likes,
                  isLikedByCurrentUser: post.isLikedByCurrentUser,
                  onLikePressed: () {
                    feed.toggleLike(post);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(
                          post: post,
                          feedController: feed,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewPostScreen()),
            );

            if (result != null) {
              await _loadPosts(); 
            }
          } catch(e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erro: $e")),
            );
          }

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
