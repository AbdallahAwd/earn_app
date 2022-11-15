import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earnlia/core/resources/strings.dart';
import 'package:earnlia/core/services/cache.dart';
import 'package:earnlia/core/utils/conponents.dart';
import 'package:earnlia/features/login/data/models/code_model.dart';
import 'package:earnlia/features/login/data/models/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/usage.dart';

abstract class BaseLoginRemoteDataSource {
  //base login
  Future<UserCredential> login(
      {required String email, required String password});
  Future<UserCredential> facebookLogin(bool isSignin);
  //google
  Future<UserCredential> googleLogin(bool isSignin);
  //save registered user
  Future<void> saveUserData(
      {required String name, required String email, required String uId});
  //register
  Future<UserCredential> registerUser(
      {required String name, required String email, required String password});

  Future<void> saveCode(
    String code,
    String uId,
  );
  Future<void> signOut();
}

class LoginRemoteDataSource extends BaseLoginRemoteDataSource {
  @override
  Future<UserCredential> facebookLogin(bool isSignin) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final user = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      if (isSignin) {
        saveUserData(
            name: user.user!.displayName!,
            email: user.user!.email!,
            uId: user.user!.uid);
      }

      await Cache.setData(key: 'uId', value: user.user!.uid);

      return user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserCredential> googleLogin(bool isSignin) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'Please choose an account',
      );
    }
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);

    await Cache.setData(key: 'uId', value: user.user!.uid);
    if (isSignin) {
      saveUserData(
          name: user.user!.displayName!,
          email: user.user!.email!,
          uId: user.user!.uid);
    }

    return user;
  }

  @override
  Future<UserCredential> login(
      {required String email, required String password}) async {
    try {
      final UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await Cache.setData(key: 'uId', value: user.user!.uid);
      return user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    Cache.removeData('uId');
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> saveUserData(
      {required String name,
      required String email,
      required String uId}) async {
    final model = LoginModel(
        name: name,
        email: email,
        uId: uId,
        refferalCode: '#${uId.substring(0, 7)}',
        balance: 0,
        usage: Usage(
            monday: 0,
            tuesday: 0,
            wednesday: 0,
            thursday: 0,
            friday: 0,
            saturday: 0,
            sunday: 0),
        isInvited: false,
        lastBalanceUpdate: C.formattedDate,
        avatar:
            AppStrings.avatars[Random().nextInt(AppStrings.avatars.length - 1)],
        location: Cache.getData(key: 'location')!);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toJson());
    saveCode('#${uId.substring(0, 7)}', uId);
  }

  @override
  Future<UserCredential> registerUser(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      saveUserData(
        name: name,
        email: email,
        uId: user.user!.uid,
      );

      await Cache.setData(key: 'uId', value: user.user!.uid);

      return user;
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: e.plugin, message: e.message);
    }
  }

  @override
  Future<void> saveCode(String code, String uId) async {
    try {
      CodeModel model = CodeModel(uId);

      await FirebaseFirestore.instance
          .collection('codes')
          .doc(code)
          .set(model.toJson());
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: e.plugin, message: e.message);
    }
  }
}
