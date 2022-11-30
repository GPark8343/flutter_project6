import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:ifc_project1/providers/auth/user_check.dart';

import 'package:provider/provider.dart';

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

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;

      final userCheck = Provider.of<UserCheck>(context, listen: false);
      await userCheck.userCheck();
      var isEnrolled = userCheck.isEnrolled;
      var isUser;
      print('asdada: $isEnrolled');
     await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user?.uid)
          .get()
          .then((value) => isUser = value.data()?['username']);
      print('isUser: $isUser');
      if (isUser == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user?.uid)
            .set({
          'username': user?.displayName,
          'email': user?.email,
          'image_url': user?.photoURL,
          'uid': authResult.user?.uid,
          'school': 'none',
          'department': 'none',
          'gender': 'none',
        });
      }

      // 여기서부터 제출해야 함

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
