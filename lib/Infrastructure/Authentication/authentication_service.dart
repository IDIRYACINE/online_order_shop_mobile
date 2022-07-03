// ignore_for_file: unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:online_order_shop_mobile/Infrastructure/Authentication/iauthentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_order_shop_mobile/Infrastructure/Exceptions/auth_exceptions.dart';
import 'package:online_order_shop_mobile/Infrastructure/Exceptions/server_exceptions.dart';

class FirebaseAuthenticationService implements IAuthenticationService {
  final FirebaseAuth _auth;
  late User _user;
  final FirebaseFirestore _firestore;
  late String _smsCodeId;
  int? _forceSmsResendToken;

  FirebaseAuthenticationService(this._auth, this._firestore);

  @override
  Future<bool> accountIsActive() async {
    //_user.emailVerified &&
    //&& _user.phoneNumber != null fireAuth cant use both email and phone
    // need a fix !
    if (_auth.currentUser != null) {
      return true;
    }
    return false;
  }

  @override
  Future<void> confirmNewPassword(
      {required String code, required String newPassword}) async {
    _auth.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  @override
  Future<void> confirmPhoneVerification({required String smsCode}) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _smsCodeId, smsCode: smsCode);
      linkAuthProviderWithProfile(authProvider: phoneAuthCredential);
    } catch (e) {
      throw InvalidVerificationCode();
    }
  }

  @override
  Future<void> linkAuthProviderWithProfile({required authProvider}) async {
    try {
      _user.linkWithCredential(authProvider);
    } catch (e) {
      throw AccountAlreadyLinked();
    }
  }

  @override
  Future<void> requestVerificationCode({required String email}) async {
    try {
      _user.sendEmailVerification();
    } catch (e) {
      throw NetworkError();
    }
  }

  @override
  Future<void> confirmVerificationCode(
      {required String code,
      required VoidCallback onSucess,
      required VoidCallback onFail}) async {
    _auth
        .applyActionCode(code)
        .then((value) => () {
              onSucess();
            })
        .catchError((onError) {
      onFail();
    });
  }

  @override
  Future<void> requestNewPassword() async {
    try {
      _auth.sendPasswordResetEmail(email: _user.email!);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw InvalidUser();
      } else {
        throw NetworkError();
      }
    }
  }

  @override
  Future<void> requestPhoneVerification(
      {required String phone,
      required Function onVerificationCompleted,
      required Function onSmsCodeSent}) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (phoneAuthCredential) {
            linkAuthProviderWithProfile(authProvider: phoneAuthCredential);
            _user.reload;
            onVerificationCompleted();
          },
          verificationFailed: (exception) {},
          codeSent: (codeId, forceTokenResendId) {
            _smsCodeId = codeId;
            _forceSmsResendToken = forceTokenResendId;
            onSmsCodeSent();
          },
          codeAutoRetrievalTimeout: (exception) {});
    } catch (e) {
      throw InvalidVerificationCode();
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser!;
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        throw InvalidLoginInfos();
      } else {
        throw InvalidUser();
      }
    }
  }

  @override
  Future<void> signOut() async {
    _auth.signOut();
  }

  @override
  Future<void> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String fullName,
      required String phoneNumber}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        _user = value.user!;
        _user.updateDisplayName(fullName);
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          throw EmailAlreadyUsed();
        case "invalid-email":
          throw InvalidEmail();
        case "weak-password":
          throw WeakPassword();
        default:
          throw UnexpectedError();
      }
    }
  }

  @override
  Future<void> updateEmail({required String newEmail}) async {
    try {
      _user.verifyBeforeUpdateEmail(newEmail);
    } catch (e) {
      throw NetworkError();
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    try {
      _user.updatePassword(newPassword);
    } catch (e) {
      throw NetworkError();
    }
  }

  @override
  String getId() {
    return _auth.currentUser!.uid;
  }

  Future<void> updateUsername({required String newUsername}) async {
    _user.updateDisplayName(newUsername);
  }

  @override
  String getEmail() {
    return _user.email!;
  }

  @override
  String getUsername() {
    return _user.displayName!;
  }

  @override
  String getPhoneNumber() {
    return _user.phoneNumber!;
  }

  @override
  Future<void> updateFullName({required String fullName}) async {
    _user.updateDisplayName(fullName);
  }
}
