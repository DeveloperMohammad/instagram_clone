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



//! Comment Card Code
// return Container(
    //   padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    //   child: Row(
    //     children: [
    //       CircleAvatar(
    //         backgroundImage: NetworkImage(
    //           'https://th.bing.com/th/id/R.86ddf59f73f9ad652fa8d5aa4b91803b?rik=FkmJyBJWUlailg&pid=ImgRaw&r=0',
    //         ),
    //         radius: 18,
    //       ),
    //       Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.only(left: 16),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               RichText(
    //                 text: TextSpan(
    //                   children: [
    //                     TextSpan(
    //                       text: 'username',
    //                       style: TextStyle(fontWeight: FontWeight.bold),
    //                     ),
    //                     TextSpan(
    //                       text: 'Here are my real comment things',
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 4),
    //                 child: Text(
    //                   '6/19/2022',
    //                   style: TextStyle(
    //                     fontSize: 12,
    //                     fontWeight: FontWeight.w400,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Container(
    //         padding: const EdgeInsets.all(8),
    //         child: const Icon(Icons.favorite, size: 16),
    //       ),
    //     ],
    //   ),
    // );