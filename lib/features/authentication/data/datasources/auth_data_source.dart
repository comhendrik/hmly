import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/models/user_model.dart';
import 'package:hmly/features/authentication/presentation/widgets/change_user_attributes_widget.dart';
import 'package:pocketbase/pocketbase.dart';
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
  Future<void> requestEmailChange(String newEmail, UserData user);
  Future<void> requestVerification(String email);
  Future<UserDataModel> refreshAuthData();
  Future<void> deleteUser(UserData user);
}

class AuthDataSourceImpl implements AuthDataSource {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthDataSourceImpl();

  @override
  Future<void> addAuthDataToHousehold(String userID, String householdID) async {
    final body = <String, dynamic>{
      "household": householdID,
    };
    try {
     // final household = await householdRecordService.getOne(householdID);
      final household = [];
      bool isAllowed = false;
      for (String id in household) {
        if (id == userID) {
          isAllowed = true;
        }
      }
      if (!isAllowed) {
        throw KnownException("You are ID is not allowed in this institution, please contact the admin.");
      }
      //final _ = await userRecordService.update(userID, body: body);
    } on ClientException catch (err) {
      throw ServerException(response: err.response);
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
        'admin': userRef, // Store the DocumentReference to the user
        'allowedUsers': [userRef]
      };

      // Add the post data with the document reference to the 'posts' collection
      final household = await firestore.collection('households').add(body);

      body = {
        'household': household,
      };

      userRef.update(body);

      return household.id;
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
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
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> login(String email, String password) async {
    try {
      final _ = await auth.signInWithEmailAndPassword(email: email, password: password);
      return await loadUserData();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (err) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> signUp(String email, String password, String passwordConfirm, String name) async {
    //TODO: Localization
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
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await auth.signOut();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> changeUserAttributes(String input, String? confirmationPassword, String? oldPassword, UserData user, UserChangeType type) async {
    try {
      //TODO: format to firebase
      Map<String, dynamic> data = {};
      switch (type) {
        case UserChangeType.email:

          throw Exception("Type email shouldn't be used in this context!!");

        case UserChangeType.name || UserChangeType.username:

          data.addAll({type.stringKey : input});
         // final result = await userRecordService.update("//TODO: should be changed", body: data);
          return await loadUserData();

        case UserChangeType.password:

          if (confirmationPassword == null || oldPassword == null) throw Exception("No confirmation or old password");
          data.addAll({
            type.stringKey : input,
            "oldPassword" : oldPassword,
            "passwordConfirm" : confirmationPassword,
          });
          //final result = await userRecordService.update("//TODO: should be changed", body: data);
          return await loadUserData();
      }
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> requestNewPassword(String userEmail) async {

    try {
      await auth.sendPasswordResetEmail(email: userEmail);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> requestEmailChange(String newEmail, UserData user) async {
    try {
      await auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> requestVerification(String email) async {
    try {
      await auth.currentUser?.sendEmailVerification();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<UserDataModel> refreshAuthData() async {
    try {
      await auth.currentUser?.reload();
      return await loadUserData();
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteUser(UserData user) async {
    try {
      //TODO handle user deletion properly
      final curUser = auth.currentUser;

      if(curUser == null) {
        throw UnknownException();
      }

      await auth.currentUser?.delete();
      await firestore.collection("users").doc(user.id).delete();

    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } on FirebaseAuthException catch(err) {
      if (err.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      }
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

    Future<void> _reauthenticateAndDelete() async {
      try {
        final providerData = auth.currentUser!.providerData.first;
        final authCredential = AuthCredential(providerId: providerData.providerId, signInMethod: 'password');

        await auth.currentUser!.reauthenticateWithCredential(authCredential);

        await auth.currentUser?.delete();
      } catch (e) {
        throw KnownException(e.toString());
      }
    }
}