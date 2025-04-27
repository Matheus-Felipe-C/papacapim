import 'package:flutter/material.dart';
import 'package:papacapim/features/auth/controllers/authController.dart';
import 'package:papacapim/features/auth/models/user.dart';
import 'package:papacapim/features/feed/controllers/feedController.dart';
import 'package:papacapim/features/feed/views/newPostScreen.dart';
import 'package:papacapim/features/feed/views/postCard.dart';
import "package:papacapim/features/feed/views/PostDetailScreen.dart";

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final FeedController feedController = FeedController();
  final AuthController authController = AuthController();
  final user = User( name: 'testing', username: 'testing');
  bool _isLoading = false; // Adicionado estado para controle de loading

  // Função para carregar/recarregar os posts
  Future<void> _loadPosts({bool refresh = false}) async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // await feedController.loadPosts(refresh: refresh);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar posts: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPosts(); // Carrega os posts inicialmente
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
      body: RefreshIndicator(
        onRefresh: () => _loadPosts(refresh: true), // Atualiza os posts quando puxar para baixo
        child: _isLoading && feedController.posts.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: feedController.posts.length,
                itemBuilder: (context, index) {
                  final post = feedController.posts[index];
                  return PostCard(
                    message: post.message,
                    username: user.username,
                    likes: post.likes,
                    isLikedByCurrentUser: post.isLikedByCurrentUser,
                    onLikePressed: () {
                      setState(() {
                        feedController.toggleLike(post);
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(
                            post: post,
                            feedController: feedController,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPost = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPostScreen()),
          );

          if (newPost != null && user != null) {
            setState(() {
              feedController.addPost(newPost["message"], user);
            });
          } else if (authController == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "Você precisa estar autenticado para criar um novo post.")),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
