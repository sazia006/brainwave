import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ ADDED THIS GETTER (Fixes the red underline in ViewModel)
  User? get currentUser => _auth.currentUser;

  // --- Getter for ViewModel to check UID ---
  String? get currentUid => _auth.currentUser?.uid;

  // --- 1. Sign Up ---
  Future<String?> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null) {
        await _db.collection("users").doc(cred.user!.uid).set({
          "uid": cred.user!.uid,
          "name": name,
          "email": email,
          "role": "student", // Default role
          "verified": false,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred during sign up";
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  // --- 2. Login ---
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred during login";
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  // --- 3. Reset Password ---
  Future<String?> resetPasswordForUser(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        return null;
      } else {
        return "User not found or not logged in.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return "Security: Please log out and log in again to change password.";
      }
      return e.message;
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  // --- 4. Fetch User Role ---
  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'] ?? 'student';
      }
    } catch (e) {
      print("Error fetching role: $e");
    }
    return 'student';
  }

  // --- 5. Sign Out ---
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- 6. Get User Details ---
  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _db.collection("users").doc(uid).get();
        return doc.data();
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }
}
