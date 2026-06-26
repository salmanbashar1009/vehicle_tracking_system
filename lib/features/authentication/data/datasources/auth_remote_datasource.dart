import 'package:firebase_auth/firebase_auth.dart';
import 'package:vehicle_tracking_system/core/errors/exceptions.dart';
import 'package:vehicle_tracking_system/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String role,
  });
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDatasourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(message: 'Sign in failed');
      }

      return UserModel(
        id: credential.user!.uid,
        email: credential.user!.email ?? email,
        displayName: credential.user!.displayName,
        photoUrl: credential.user!.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _getAuthErrorMessage(e.code), code: e.code);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(message: 'Sign up failed');
      }

      return UserModel(
        id: credential.user!.uid,
        email: credential.user!.email ?? email,
        role: role,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _getAuthErrorMessage(e.code), code: e.code);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    });
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'Authentication failed';
    }
  }
}