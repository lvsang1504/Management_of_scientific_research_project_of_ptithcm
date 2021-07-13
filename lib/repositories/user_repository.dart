import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'package:management_of_scientific_research_project_of_ptithcm/models/user_api.dart';
import 'dart:convert' as convert;

import 'package:management_of_scientific_research_project_of_ptithcm/models/user_response.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  // ignore: missing_return
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<void> resetPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User> getUser() async {
    return await _firebaseAuth.currentUser;
  }

  Future<String> uploadPhoto(File file, String path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      final uploadTask = ref.putFile(file);
      await uploadTask;
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<String> getPhoto(String path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Error: $e");
    }
    return null;
  }

  ///////////////////// Call API to SQL Server ////////////////////////
  ///
  ///
  Future<UserApi> getUserApi(String firebaseKey) async {
    try {
      final response = await http.get(Uri.parse(
          'https://ptithcm.azurewebsites.net/api/users/firebaseKey=$firebaseKey'));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        return UserApi.fromJson(jsonResponse);
      } else if(response.statusCode == 404){
        print("Not found!");
      }
      else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future<bool> createUser(UserApi userApi) async {
    try {
      final response = await http.post(
        Uri.parse('https://ptithcm.azurewebsites.net/api/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(userApi.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<bool> updateUser(UserApi userApi, String keyFirebase) async {
    try {
      final response = await http.put(
        Uri.parse('https://ptithcm.azurewebsites.net/api/users/update=$keyFirebase'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(userApi.toJson()),
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }
}
