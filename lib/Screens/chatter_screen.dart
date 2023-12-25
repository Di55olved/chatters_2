// ignore_for_file: prefer_const_constructors, prefer_final_fields
import 'dart:io';
import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Widgets/messages.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatterScreen extends StatefulWidget {
  final Cuser user;
  const ChatterScreen({super.key, required this.user});

  @override
  State<ChatterScreen> createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  //all messages
  //Cuser currentUser = APIs.user.uid;
  List<Messages> _msglist = [];

  final _textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            //if user presses back button, emoji unselected and app does not close
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox();
                    }

                    final data = snapshot.data?.docs;

                    _msglist = data
                            ?.map((doc) => Messages.fromJson(
                                doc.data() as Map<String, dynamic>))
                            .toList() ??
                        [];
                    if (data != null && data.isNotEmpty) {
                      return ListView.builder(
                        reverse: true,
                        itemCount: _msglist.length,
                        itemBuilder: (context, index) {
                          return MessageCard(messages: _msglist[index]);
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Say Hi 👋",
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    }
                  },
                )),
                if (_isUploading == true)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.35,
                    child: EmojiPicker(
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                        // Set it to null to hide the Backspace-Button
                      },
                      textEditingController:
                          _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 *
                            (Platform.isIOS
                                ? 1.30
                                : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
            )),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 5,
            leading: SizedBox(
              width:
                  MediaQuery.of(context).size.width * 0.09, // Adjust as needed
              height:
                  MediaQuery.of(context).size.width * 0.09, // Adjust as needed

              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.03),
                child: CachedNetworkImage(
                  width: MediaQuery.sizeOf(context).width * .045,
                  height: MediaQuery.sizeOf(context).height * .045,
                  imageUrl: widget.user.image!,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            title: Text(widget.user.name!, style: TextStyle(fontSize: 14)),
            subtitle: const Text(
              'Last seen, 10:53',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.01,
          horizontal: MediaQuery.sizeOf(context).width * 0.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 26)),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        for (var i in images) {
                          //iterate post to firebase
                          setState(() {
                            _isUploading = true;
                          });
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image from camera
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          setState(() {
                            _isUploading = true;
                          });

                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() {
                            _isUploading = false;
                          });

                          // for hiding bottom sheet
                          //   Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}