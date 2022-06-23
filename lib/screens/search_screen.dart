import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(hintText: 'Search for username'),
          onFieldSubmitted: (_) {
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: snapshot.data.docs[index]['uid'],
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data.docs[index]['photoUrl']),
                      ),
                      title: Text(snapshot.data!.docs[index]['username']),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return MasonryGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return MediaQuery.of(context).size.width > webScreenSize
                          ? StaggeredGridTile.extent(
                              crossAxisCellCount: (index % 7 == 0) ? 1 : 1,
                              mainAxisExtent: (index % 7 == 0) ? 1 : 1,
                              child: Image.network(
                                snapshot.data.docs[index]['postUrl'],
                              ),
                            )
                          : StaggeredGridTile.extent(
                              crossAxisCellCount: (index % 7 == 0) ? 2 : 1,
                              mainAxisExtent: (index % 7 == 0) ? 2 : 1,
                              child: Image.network(
                                snapshot.data.docs[index]['postUrl'],
                              ),
                            );
                    },
                  );
                }
              },
            ),
    );
  }
}


// class CustomSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         }, 
//         icon: const Icon(Icons.clear)
//       ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon: const Icon(Icons.arrow_back),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Text('Here are the results'),
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Text('Suggestions Appear now'),
//       ),
//     );
//   }
// }
