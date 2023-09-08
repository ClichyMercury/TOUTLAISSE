import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threads/auth/signup/email.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _linkController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _linkController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  File? _image;

  Future<void> getImage(BuildContext context, ImageSource source,
      Function(File) onImageSelected) async {
    ImagePicker()
        .pickImage(source: source, imageQuality: 100)
        .then((XFile? file) async {
      await ImageCropper.platform.cropImage(
        sourcePath: file!.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
      ).then((value) => setState(() {
            onImageSelected(File(value!.path));
          }));
    });
  }

  Widget _body(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        height: 110,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/TOUTLAISSE.png"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Customize your TL profile.",
                  style: TextStyle(
                      color: Color.fromARGB(255, 96, 96, 96),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
      Container(
          margin: EdgeInsets.only(top: 75),
          height: 300,
          width: 330,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 25, 25, 25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 10,
                            ),
                            Text(
                              "Name",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            CupertinoTextField(
                              controller: _nameController,
                              prefix: Icon(
                                Icons.lock_outline_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              placeholder: 'Name',
                              placeholderStyle:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Container(
                              height: 5,
                            ),
                            Container(
                              width: 300,
                              height: 0.5,
                              color: Colors.grey,
                            ),
                            Container(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => CupertinoTheme(
                                    data: CupertinoThemeData(
                                      brightness: Brightness
                                          .dark, // Définir le mode sombre
                                    ),
                                    child: CupertinoActionSheet(
                                      title: Text('Changer de photo de profil'),
                                      message: Text(
                                          'Ta photo de profil est visible par tous et permetttra à tes amis de t\'ajoyter plus facilement'),
                                      actions: <Widget>[
                                        CupertinoActionSheetAction(
                                          child: Text('Photothèque'),
                                          onPressed: () {
                                            getImage(
                                                context, ImageSource.gallery,
                                                (file) {
                                              setState(() {
                                                _image = file;
                                              });
                                            });
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text('Appareil photo'),
                                          onPressed: () {
                                            getImage(
                                                context, ImageSource.camera,
                                                (file) {
                                              setState(() {
                                                _image = file;
                                              });
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text(
                                            'Supprimer la photo de profil',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text('Annuler'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25,
                            backgroundImage: (_image != null
                                ? FileImage(_image!)
                                : CachedNetworkImageProvider(
                                    scale: 10,
                                    "https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg",
                                  ) as ImageProvider)),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                      CupertinoTextField(
                        controller: _bioController,
                        prefix: Icon(
                          Icons.add,
                          size: 15,
                          color: Colors.white,
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        placeholder: 'Write bio',
                        placeholderStyle:
                            TextStyle(color: Colors.grey, fontSize: 16),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        height: 0.5,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 20,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Link",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                      CupertinoTextField(
                        controller: _linkController,
                        prefix: Icon(
                          Icons.link,
                          size: 15,
                          color: Colors.white,
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        placeholder: 'Add Link',
                        placeholderStyle:
                            TextStyle(color: Colors.grey, fontSize: 16),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        height: 0.5,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 20,
                      )
                    ],
                  ),
                ],
              ))),
      Container(
        height: 20,
      ),
      GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmailPage(
                          name: _nameController.text,
                          bio: _bioController.text,
                          link: _linkController.text,
                          image: _image,
                        )));
          },
          child: GestureDetector(
            onTap: (() => Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const EmailPage()))),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 80,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.arrow_right,
                    color: Colors.black,
                  ),
                  Text(
                    "Suivant",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )
                ],
              ),
            ),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }
}
