// Utility class used to retrieve data about a logged in user

import 'package:firebase_auth/firebase_auth.dart';

class UserUtil {
    static bool isUserLoggedIn() {
        if (FirebaseAuth.instance.currentUser != null) {
            return true;
        } else
            return false;
    }
}