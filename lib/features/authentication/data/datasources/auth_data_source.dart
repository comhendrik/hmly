import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/models/user_model.dart';
import 'package:hmly/features/authentication/presentation/widgets/change_user_attributes_widget.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  Future<void> addAuthDataToHousehold(String userID, String householdID);
  Future<String> createHouseholdAndAddAuthData(String userID);
  Future<void> leaveHousehold(UserData user);
  Future<UserDataModel> login(String email, String password);
  Future<UserDataModel> signUp(String email, String password, String passwordConfirm, String name);
  Future<void> logout();
  Future<UserDataModel> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, UserData user, UserChangeType type);
  Future<void> requestNewPassword(String userEmail);
  Future<void> requestEmailChange(String newEmail, String password, UserData user);
  Future<void> requestVerification();
  Future<UserDataModel> refreshAuthData();
  Future<void> deleteUser(UserData user, String password);
}

class AuthDataSourceImpl implements AuthDataSource {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthDataSourceImpl();

  @override
  Future<void> addAuthDataToHousehold(String userID, String householdID) async {

    try {
      final householdRef = firestore.collection("households").doc(householdID);

      final snap = await householdRef.get();

      bool isAllowed = false;
      for (final allowedUser in snap.data()?["allowedUsers"] as List<dynamic>) {
        if (allowedUser.id == userID) {
          isAllowed = true;
        }
      }
      if (!isAllowed) {
        throw KnownException("You are ID is not allowed in this institution");
      }
      DocumentReference userRef = firestore.collection('users').doc(userID);

      Map<String, dynamic> body = {
        'household': householdRef,
      };

      userRef.update(body);
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } on KnownException catch (err){
      throw KnownException(err.response["message"]);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<String> createHouseholdAndAddAuthData(String userID) async {

    try {
      DocumentReference userRef = firestore.collection('users').doc(userID);

      Map<String, dynamic> body = {
        'allowedUsers': [userRef]
      };

      // Add the post data with the document reference to the 'posts' collection
      final household = await firestore.collection('households').add(body);

      body = {
        'household': household,
      };

      userRef.update(body);

      return household.id;
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> leaveHousehold(UserData user) async {
    try {
      await firestore.collection("users").doc(user.id).update({
        "household": FieldValue.delete(), // Use FieldValue.delete() to remove the field
      });
      //TODO: Delete household if user is alone in household
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> login(String email, String password) async {
    try {
      final _ = await auth.signInWithEmailAndPassword(email: email, password: password);
      return await loadUserData();
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (err) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> signUp(String email, String password, String passwordConfirm, String name) async {
    if(password != passwordConfirm) throw KnownException("Please confirm the password with the real one");
    Map<String, dynamic> body = {
      'name' : name
    };
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);

      await firestore.collection("users").doc(auth.currentUser!.uid).set(body);

      await auth.signOut();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return await loadUserData();
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await auth.signOut();
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, UserData user, UserChangeType type) async {
    try {
      final DocumentReference userRef = firestore.collection("users").doc(user.id);
      switch (type) {
        case UserChangeType.email:

          throw Exception("Type email shouldn't be used in this context!!");

        case UserChangeType.name:

          await userRef.update({"name": input});
          return await loadUserData();

        case UserChangeType.password:

          if(input != confirmationPassword) throw Exception("Check confirmation password");
          if(auth.currentUser == null) throw Exception("Please login");

          auth.currentUser!.updatePassword(input);

          return await loadUserData();
      }
    } on FirebaseAuthException catch(err) {
      if (err.code == "requires-recent-login") {
        try {
          await _reauthenticateAndChangePassword(input, oldPassword!);

        } catch (e) {
          throw UnknownException();
        }
      }
      return await loadUserData();
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> requestNewPassword(String userEmail) async {

    try {
      await auth.sendPasswordResetEmail(email: userEmail);
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> requestEmailChange(String newEmail, String password, UserData user) async {
    try {
      final authCredential = EmailAuthProvider.credential(
          email: auth.currentUser!.email!, password: password
      );

      await auth.currentUser!.reauthenticateWithCredential(authCredential);
      await auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseException catch(e) {
      throw ServerException(response: {"message" : e.toString()});
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> requestVerification() async {
    try {
      await auth.currentUser?.sendEmailVerification();
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> refreshAuthData() async {
    try {
      await auth.currentUser?.reload();
      return await loadUserData();
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteUser(UserData user, String password) async {
    try {
      //TODO handle user deletion properly
      final curUser = auth.currentUser;

      if(curUser == null) {
        throw KnownException("No logged in user");
      }

      await auth.currentUser!.delete();
      await firestore.collection("users").doc(user.id).delete();

    //TODO: Implement new exception type
    } on FirebaseAuthException catch(err) {
      if (err.code == "requires-recent-login") {
        try {
          await _reauthenticateAndDelete(password);
        } catch (e) {
          throw UnknownException();
        }
      }
    } on FirebaseException catch(e) {
      throw KnownException(e.toString());
    } catch (_) {
      throw UnknownException(); //TODO implement a code for the function to be shown
    }
  }

  Future<UserDataModel> loadUserData() async {
    if (auth.currentUser == null) throw UnknownException(); //TODO: implement new exception type
    try {
      final userData = await firestore.collection("users").doc(auth.currentUser!.uid).get();
      if (userData.data() == null) throw UnknownException(); //TODO: implement new exception type
      return UserDataModel.fromJSON(userData.data()!, auth.currentUser!.uid, auth.currentUser!.email!, auth.currentUser!.emailVerified);
    } on FirebaseException catch(e) {
      throw KnownException(e.toString()); //TODO: Implement new exception type
    } catch(_) {
      throw UnknownException();
    }
  }

  Future<void> _reauthenticateAndDelete(String password) async {
    try {
      final authCredential = EmailAuthProvider.credential(
          email: auth.currentUser!.email!, password: password
      );

      await auth.currentUser!.reauthenticateWithCredential(authCredential);

      await auth.currentUser!.delete();
    } catch (e) {
      throw KnownException(e.toString());
    }
  }

  Future<void> _reauthenticateAndChangePassword(String password, String oldPassword) async {
    try {
      final authCredential = EmailAuthProvider.credential(
          email: auth.currentUser!.email!, password: oldPassword
      );

      await auth.currentUser!.reauthenticateWithCredential(authCredential);
      await auth.currentUser!.updatePassword(password);
    } catch (e) {
      throw KnownException(e.toString());
    }
  }
}