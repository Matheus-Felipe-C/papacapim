import 'package:papacapim/features/auth/controllers/authController.dart';

import '../models/user.dart';

class ProfileController {

  void updateProfile({
    required String name, 
    required String username,
  }) {
    authController.currentUser!.name = name;
    authController.currentUser!.username = username;
  }

  User getCurrentUser() {
    // Replace this with actual data fetching (e.g., from an API or database)
    return authController.currentUser!;
  }
}
