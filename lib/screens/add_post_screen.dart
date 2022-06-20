import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;

  Uint8List? _file;
  late final TextEditingController _descriptionController =
      TextEditingController();

  void postImage({
    required String uid,
    required String username,
    required String profileUrl,
  }) async {
    try {
      setState(() => isLoading = true);
      String res = await FirestoreMethods().uploadPost(
        description: _descriptionController.text,
        username: username,
        file: _file!,
        uid: uid,
        profileImage: profileUrl,
      );

      setState(() => isLoading = false);

      if (res == 'success') {
        showSnackBar('The Image was posted successfully', context);
        setState(() {
          clearImage();
          _descriptionController.text = '';
        });
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(18),
            child: const Text('Take a photo'),
            onPressed: () async {
              Navigator.pop(context);
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() => _file = file);
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(18),
            child: const Text('Pick from Gallery'),
            onPressed: () async {
              Navigator.pop(context);
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() => _file = file);
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(18),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;

    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearImage,
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post'),
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    uid: user.uid,
                    username: user.username,
                    profileUrl: user.photoUrl,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                isLoading ? const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 25),
                  child:  LinearProgressIndicator(),
                ) : const SizedBox.shrink(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Type a status',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
