import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ifc_project1/screens/auth/auth_data_screen.dart';
import 'package:ifc_project1/widgets/Auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // final _auth = FirebaseAuth.instance;
  // var _isLoading = false;

  // void _submitAuthForm(String email, String password, String username,
  //     File? image, bool isLogin, BuildContext ctx) async {
  //   UserCredential authResult;
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     if (isLogin) {
  //       authResult = await _auth.signInWithEmailAndPassword(
  //           email: email, password: password);
  //     } else {
  //       authResult = await _auth.createUserWithEmailAndPassword(
  //           email: email, password: password);

  //       final ref = FirebaseStorage.instance
  //           .ref()
  //           .child('user_image')
  //           .child('${authResult.user?.uid}.jpg');

  //       await ref.putFile(image!);

  //       final url = await ref.getDownloadURL();

  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(authResult.user?.uid)
  //           .set({
  //         'username': username.toString(),
  //         'email': email,
  //         'image_url': url,
  //         'uid': authResult.user?.uid
  //       });
  //     }
  //   } on PlatformException catch (error) {
  //     var message = 'An error occurred, please check your credentials!';
  //     if (error.message != null) {
  //       message = error.message!;
  //     }
  //     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //       content: Text(message),
  //       backgroundColor: Theme.of(ctx).errorColor,
  //     ));
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } catch (error) {
  //     print(error);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().catchError((onError) => print(onError));
      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential

      // 여기서부터 제출해야 함

      Navigator.of(context).pushNamed(AuthDataScreen.routeName,
          arguments: {'credential': credential});
    } catch (error) {
      print(error);
    }
  }
//  void _submitAuthForm(String email, String password, String username,
//       File? image, bool isLogin, BuildContext ctx) async {
//     UserCredential authResult;
//     try {
//       setState(() {
//         _isLoading = true;
//       });
//       if (isLogin) {
//         authResult = await _auth.signInWithEmailAndPassword(
//             email: email, password: password);
//       } else {
//         authResult = await _auth.createUserWithEmailAndPassword(
//             email: email, password: password);

//         final ref = FirebaseStorage.instance
//             .ref()
//             .child('user_image')
//             .child('${authResult.user?.uid}.jpg');

//         await ref.putFile(image!);

//         final url = await ref.getDownloadURL();

//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(authResult.user?.uid)
//             .set({
//           'username': username.toString(),
//           'email': email,
//           'image_url': url,
//           'uid': authResult.user?.uid,
//           'isBan':false
//         });
//       }
//     } on PlatformException catch (error) {
//       var message = 'An error occurred, please check your credentials!';
//       if (error.message != null) {
//         message = error.message!;
//       }
//       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(ctx).errorColor,
//       ));
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (error) {
//       print(error);
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
          padding: EdgeInsets.only(top: 110),
          child:
              // AuthForm(_submitAuthForm, _isLoading),
              Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: signInWithGoogle,
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/google_sign_in_button.png'),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
