import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:state_change_demo/src/enum/enum.dart';

class AuthController with ChangeNotifier {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<AuthController>(AuthController());
  }

  // Static getter to access the instance through GetIt
  static AuthController get instance => GetIt.instance<AuthController>();

  static AuthController get I => GetIt.instance<AuthController>();

  late StreamSubscription<User?> currentAuthedUser;

  AuthState state = AuthState.unauthenticated;

  // FirebaseAuth.instance

  // SimulatedAPI api = SimulatedAPI();

  listen() {
    currentAuthedUser =
        FirebaseAuth.instance.authStateChanges().listen(handleUserChanges);
  }

  void handleUserChanges(User? user) {
    // print(user?.email);
    // print(user?.displayName);

    if (user == null) {
      state = AuthState.unauthenticated;
    } else {
      state = AuthState.authenticated;
    }
    notifyListeners();
  }

  login(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    // User? user  = userCredential.user;
  }

  register(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    // User? user  = userCredential.user;
  }

  ///write code to log out the user and add it to the home page.
  logout() {
    return FirebaseAuth.instance.signOut();
    //should clear session
  }

  ///must be called in main before runApp
  ///
  loadSession() async {
    listen();
    User? user = FirebaseAuth.instance.currentUser;
    handleUserChanges(user);
  }

  ///https://pub.dev/packages/flutter_secure_storage or any caching dependency of your choice like localstorage, hive, or a db
}

class SimulatedAPI {
  Map<String, String> users = {"testUser": "12345678ABCabc!"};

  Future<bool> login(String userName, String password) async {
    await Future.delayed(const Duration(seconds: 4));
    if (users[userName] == null) throw Exception("User does not exist");
    if (users[userName] != password) {
      throw Exception("Password does not match!");
    }
    return users[userName] == password;
  }
}
