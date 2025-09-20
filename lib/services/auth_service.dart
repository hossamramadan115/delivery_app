import 'package:delivery/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String id,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);

      await DatabaseMethods().addUserDetails({
        'id': id,
        'name': name,
        'email': email,
        'image': "",
        'createdAt': FieldValue.serverTimestamp(),
      }, id);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw "This email is already in use.";
        case 'invalid-email':
          throw "The email address is not valid.";
        case 'weak-password':
          throw "The password is too weak. Please choose a stronger one.";
        case 'operation-not-allowed':
          throw "Email/password accounts are not enabled.";
        case 'network-request-failed':
          throw "Please check your internet connection.";
        default:
          throw e.message ?? "Sign up failed.";
      }
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }
  //     throw e.message ?? "Sign up failed";
  //   } catch (e) {
  //     throw "Unexpected error occurred";
  //   }
  // }

  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw "No user found with this email.";
        case 'wrong-password':
          throw "Incorrect password. Please try again.";
        case 'invalid-email':
          throw "The email address format is invalid.";
        case 'network-request-failed':
          throw "Please check your internet connection.";
        case 'invalid-credential':
          throw "Your login credentials are invalid or expired.";
        case 'user-disabled':
          throw "This account has been disabled. Contact support.";
        default:
          throw "Login failed. Please try again later.";
      }
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  //     throw e.message ?? "Login failed";
  //   } catch (e) {
  //     throw "Unexpected error occurred";
  //   }
  // }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount(String id) async {
    try {
      await DatabaseMethods().deleteUser(id);
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw "Error deleting account. Please try again.";
      // throw "Error deleting account: $e";
    }
  }
}
