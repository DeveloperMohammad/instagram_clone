//! This is the code to get your username from firebase
//! But now we use a firebase method instead so it got replaced
// void getUserName() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     FirebaseFirestore firestore = FirebaseFirestore.instance;

//     DocumentSnapshot snap =
//         await firestore.collection('users').doc(auth.currentUser!.uid).get();

//     log(snap.data().toString());

//     setState(() {
//       username = (snap.data() as Map<String, dynamic>)['username'];
//     });
//   }