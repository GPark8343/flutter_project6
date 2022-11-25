// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:ifc_project1/widgets/pickers/user_image_picker.dart';

// class AuthForm extends StatefulWidget {
//   AuthForm(this.submitFn, this.isLoading);

//   final void Function(String email, String password, String userName,
//       File? image, bool isLogin, BuildContext ctx) submitFn;

//   final bool isLoading;

//   @override
//   State<AuthForm> createState() => _AuthFormState();
// }

// class _AuthFormState extends State<AuthForm> {
//   final _formKey = GlobalKey<FormState>();
//   var _isLogin = true;
//   var _userEmail = '';
//   var _userName = '';
//   var _userPassword = '';
//   File? _userImageFile;

//   void _pickedImage(File image) {
//     _userImageFile = image;
//   }

  // Future<void> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   try {
  //     final GoogleSignInAccount? googleUser =
  //         await GoogleSignIn().signIn().catchError((onError) => print(onError));
  //     if (googleUser == null) return null;

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //     // Once signed in, return the UserCredential
  //     final authResult =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     final user = authResult.user;
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(authResult.user?.uid)
  //         .set({
  //       'username': user?.displayName,
  //       'email': user?.email,
  //       'image_url': user?.photoURL,
  //       'uid': authResult.user?.uid
  //     });
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // void _trySubmit() {
  //   final isValid = _formKey.currentState?.validate();
  //   FocusScope.of(context).unfocus();
  //   if (_userImageFile == null && !_isLogin) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Please pick an image.'),
  //       backgroundColor: Theme.of(context).errorColor,
  //     ));
  //     return;
  //   }
  //   if (isValid!) {
  //     _formKey.currentState?.save();
  //     widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
  //         _userImageFile, _isLogin, context);
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         margin: EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (!_isLogin) UserImagePicker(_pickedImage),
//                     TextFormField(
//                       key: ValueKey('email'),
//                       autocorrect: false,
//                       textCapitalization: TextCapitalization.none,
//                       enableSuggestions: false,
//                       validator: (value) {
//                         if (value!.isEmpty || !value.contains('@')) {
//                           return 'Please enter a valid email address.';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: InputDecoration(labelText: 'Email address'),
//                       onSaved: (value) {
//                         _userEmail = value as String;
//                       },
//                     ),
//                     if (!_isLogin)
//                       TextFormField(
//                         key: ValueKey('username'),
//                         autocorrect: true,
//                         textCapitalization: TextCapitalization.words,
//                         enableSuggestions: false,
//                         validator: (value) {
//                           if (value!.isEmpty || value.length < 4) {
//                             return 'Please enter at least 4 characters.';
//                           }
//                           return null;
//                         },
//                         decoration: InputDecoration(labelText: 'Username'),
//                         onSaved: (value) {
//                           _userName = value as String;
//                         },
//                       ),
//                     TextFormField(
//                       key: ValueKey('password'),
//                       validator: (value) {
//                         if (value!.isEmpty || value.length < 7) {
//                           return 'Password must be at least 7 characters long.';
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(labelText: 'Password'),
//                       obscureText: true,
//                       onSaved: (value) {
//                         _userPassword = value as String;
//                       },
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     if (widget.isLoading) CircularProgressIndicator(),
//                     if (!widget.isLoading)
//                       ElevatedButton(
//                           onPressed: _trySubmit,
//                           child: Text(_isLogin ? 'Login' : 'Signup')),
//                     if (!widget.isLoading)
//                       TextButton(
//                         onPressed: () {
//                           setState(() {
//                             _isLogin = !_isLogin;
//                           });
//                         },
//                         child: Text(_isLogin
//                             ? 'Create new account'
//                             : 'I already have an account'),
//                         style: TextButton.styleFrom(
//                             foregroundColor: Theme.of(context).primaryColor),
//                       ),
//                     GestureDetector(
//                       onTap: signInWithGoogle,
//                       child: Container(
//                         width: 200,
//                         height: 50,
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: AssetImage(
//                                     'assets/images/google_sign_in_button.png'),
//                                 fit: BoxFit.cover)),
//                       ),
//                     )
//                   ],
//                 )),
//           ),
//         ),
//       ),
//     );
//   }
// }
