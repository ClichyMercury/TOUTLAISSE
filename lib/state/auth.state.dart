import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as db;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:threads/helper/enum.dart';
import 'package:threads/helper/shared_prefrence_helper.dart';
import 'package:threads/helper/utility.dart';
import 'package:threads/model/user.module.dart';
import 'package:threads/state/app.state.dart';
import 'package:threads/common/locator.dart';
import 'package:path/path.dart' as path;

class AuthState extends AppStates {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  User? user;
  late String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  db.Query? _profileQuery;
  late AuthState authRepository;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  UserModel? get profileUserModel => _userModel;

  void logoutCallback() async {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    _userModel = null;
    user = null;
    _profileQuery!.onValue.drain();
    _profileQuery = null;
    _firebaseAuth.signOut();
    notifyListeners();
    await getIt<SharedPreferenceHelper>().clearPreferenceValues();
  }

  void databaseInit() {
    try {
      if (_profileQuery == null) {
        _profileQuery = kDatabase.child("profile").child(user!.uid);
        _profileQuery!.onValue.listen(_onProfileChanged);
        _profileQuery!.onChildChanged.listen(_onProfileUpdated);
      }
    } catch (error) {}
  }

  Future<String?> signIn(String email, String password, BuildContext context,
      {required GlobalKey<ScaffoldState> scaffoldKey}) async {
    try {
      isBusy = true;
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      userId = user!.uid;
      return user!.uid;
    } on FirebaseException catch (error) {
      if (error.code == 'Email Adress Not found') {
        Utility.customSnackBar(scaffoldKey, 'User not found', context);
      } else {
        Utility.customSnackBar(
            scaffoldKey, error.message ?? 'Something went wrong', context);
      }
      return null;
    } catch (error) {
      Utility.customSnackBar(scaffoldKey, error.toString(), context);

      return null;
    } finally {
      isBusy = false;
    }
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]
          // Spécifiez ici les scopes et les options selon vos besoins.
          );

      // Ensuite, vous pouvez utiliser les informations de l'Apple ID credential pour l'authentification
      // et envoyer ces informations à votre backend (par exemple, via une requête HTTP).

      // Exemple de requête HTTP vers votre backend :
      final response = await http.post(
        Uri.parse('https://votre-backend.com/apple-sign-in-endpoint'),
        body: {
          'code': credential.authorizationCode,
          // Ajoutez d'autres paramètres selon vos besoins, comme le nonce et l'état.
        },
      );

      // Traitez la réponse de votre backend selon votre logique d'authentification.

      // Exemple de traitement de la réponse :
      if (response.statusCode == 200) {
        // L'authentification avec Apple a réussi.
        // Vous pouvez effectuer les actions nécessaires, par exemple, connecter l'utilisateur.
      } else {
        // L'authentification avec Apple a échoué.
        // Gérez les erreurs et informez l'utilisateur.
      }
    } catch (error) {
      // Gérez les erreurs, par exemple, affichez un message d'erreur.
    }
  }

  Future<String?> signInWithGoogle(
    BuildContext context,
  ) async {
    try {
      isBusy = true;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // L'utilisateur a annulé la connexion Google.
        isBusy = false;
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);
      user = result.user;
      userId = user!.uid;
      return user!.uid;
    } on FirebaseAuthException {
      'ERROR_MISSING_GOOGLE_ID_TOKEN';
      'missing Google ID Token';
    } finally {
      isBusy = false;
    }
     return null;
  }

  Future<String?> signInWithFacebook(BuildContext context,
      {required GlobalKey<ScaffoldState> scaffoldKey}) async {
    try {
      isBusy = true;

      final LoginResult result = await FacebookAuth.instance.login();

      // ignore: unnecessary_null_comparison
      if (result == null) {
        // L'utilisateur a annulé la connexion Facebook.
        isBusy = false;
        return null;
      }

      final AuthCredential credential =
          FacebookAuthProvider.credential(result as String);

      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      user = authResult.user;
      userId = user!.uid;

      return user!.uid;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        Utility.customSnackBar(scaffoldKey, 'User not found', context);
      } else {
        Utility.customSnackBar(
            scaffoldKey, error.message ?? 'Something went wrong', context);
      }
      return null;
    } catch (error) {
      Utility.customSnackBar(scaffoldKey, error.toString(), context);
      return null;
    } finally {
      isBusy = false;
    }
  }

  Future<String?> signUp(UserModel userModel, BuildContext context,
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required String password}) async {
    try {
      isBusy = true;
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      );
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;
      kAnalytics.logSignUp(signUpMethod: 'register');
      result.user!.updateDisplayName(
        userModel.displayName,
      );
      result.user!.updatePhotoURL(userModel.profilePic);

      _userModel = userModel;
      _userModel!.key = user!.uid;
      _userModel!.userId = user!.uid;
      createUser(_userModel!, newUser: true);
      return user!.uid;
    } catch (error) {
      isBusy = false;
      Utility.customSnackBar(scaffoldKey, error.toString(), context);
      return null;
    }
  }

  void createUser(UserModel user, {bool newUser = false}) {
    if (newUser) {
      user.userName =
          Utility.getUserName(id: user.userId!, name: user.displayName!);
      kAnalytics.logEvent(name: 'create_newUser');
    }

    kDatabase.child('profile').child(user.userId!).set(user.toJson());
    _userModel = user;
    isBusy = false;
  }

  Future<User?> getCurrentUser() async {
    try {
      isBusy = true;
      user = _firebaseAuth.currentUser;
      if (user != null) {
        await getProfileUser();
        authStatus = AuthStatus.LOGGED_IN;
        userId = user!.uid;
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      isBusy = false;
      return user;
    } catch (error) {
      isBusy = false;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  Future<void> updateUserProfile(UserModel? userModel,
      {File? image, File? bannerImage}) async {
    try {
      if (image == null && bannerImage == null) {
        createUser(userModel!);
      } else {
        if (image != null) {
          userModel!.profilePic = await _uploadFileToStorage(image,
              'user/profile/${userModel.userName}/${path.basename(image.path)}');
          var name = userModel.displayName ?? user!.displayName;
          _firebaseAuth.currentUser!.updateDisplayName(name);
          _firebaseAuth.currentUser!.updatePhotoURL(userModel.profilePic);
        }

        if (userModel != null) {
          createUser(userModel);
        } else {
          createUser(_userModel!);
        }
      }
    } catch (error) {}
  }

  Future<String> _uploadFileToStorage(File file, path) async {
    var task = _firebaseStorage.ref().child(path);

    return await task.getDownloadURL();
  }

  Future<UserModel?> getUserDetail(String userId) async {
    UserModel user;
    var event = await kDatabase.child('profile').child(userId).once();

    final map = event.snapshot.value as Map?;
    if (map != null) {
      user = UserModel.fromJson(map);
      user.key = event.snapshot.key!;
      return user;
    } else {
      return null;
    }
  }

  FutureOr<void> getProfileUser({String? userProfileId}) {
    try {
      userProfileId = userProfileId ?? user!.uid;
      kDatabase
          .child("profile")
          .child(userProfileId)
          .once()
          .then((DatabaseEvent event) async {
        final snapshot = event.snapshot;
        if (snapshot.value != null) {
          var map = snapshot.value as Map<dynamic, dynamic>?;
          if (map != null) {
            if (userProfileId == user!.uid) {
              _userModel = UserModel.fromJson(map);

              getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
            }
          }
        }
        isBusy = false;
      });
    } catch (error) {
      isBusy = false;
    }
  }

  void _onProfileChanged(DatabaseEvent event) {
    final val = event.snapshot.value;
    if (val is Map) {
      final updatedUser = UserModel.fromJson(val);
      _userModel = updatedUser;
      getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
      notifyListeners();
    }
  }

  void _onProfileUpdated(DatabaseEvent event) {
    final val = event.snapshot.value;
    if (val is List &&
        ['following', 'followers'].contains(event.snapshot.key)) {
      final list = val.cast<String>().map((e) => e).toList();
      if (event.previousChildKey == 'following') {
        _userModel = _userModel!.copyWith(
          followingList: val.cast<String>().map((e) => e).toList(),
        );
      } else if (event.previousChildKey == 'followers') {
        _userModel = _userModel!.copyWith(
          followersList: list,
        );
      }
      getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
      notifyListeners();
    }
  }
}
