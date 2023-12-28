// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_final_fields
import 'dart:io';

import 'package:chatters_2/bloc/message_bloc/message_states.dart';
import 'package:chatters_2/core/repository/message_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Navigaitions/routes_names.dart';
import 'package:chatters_2/Support/data_utils.dart';
import 'package:chatters_2/Widgets/messages.dart';
import 'package:chatters_2/bloc/message_bloc/message_bloc.dart';
import 'package:chatters_2/bloc/message_bloc/message_event.dart';

class ChatterScreen extends StatefulWidget {
  final Cuser user;
  final MsgRepository msgRepository;
  const ChatterScreen({
    super.key,
    required this.user,
    required this.msgRepository,
  });

  @override
  State<ChatterScreen> createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  //all messages
  //Cuser currentUser = APIs.user.uid;
  List<Messages> _msglist = [];
  late MsgBloc _msgBloc;

  @override
  void initState() {
    super.initState();
    _msgBloc = MsgBloc(msgRepository: widget.msgRepository);
    _msgBloc.add(FetchMsg(user: widget.user));
    APIs.getSelfInfo();
  }

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
              backgroundColor: APIs.purple,
            ),
            body: Column(
              children: [
                Expanded(
                    child: BlocBuilder(
                        bloc: _msgBloc,
                        builder: (_, MsgState state) {
                          if (state is MsgEmpty) {
                            return const Center(child: Text('Empty state'));
                          }
                          if (state is MsgLoading) {
                            return const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          }
                          if (state is MsgLoaded) {
                            return StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: state.messages,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  _msglist = snapshot.data!.docs
                                      .map((doc) => Messages.fromJson(
                                          doc.data() as Map<String, dynamic>))
                                      .toList(); // ??
                                  //[];
                                  if (_msglist.isEmpty) {
                                    // Handle empty list
                                    return const Center(
                                      child: Text(
                                        "Say Hi 👋",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    reverse: true,
                                    itemCount: _msglist.length,
                                    itemBuilder: (context, index) {
                                      return MessageCard(
                                        messages: _msglist[index],
                                        user: widget.user,
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  // Handle error state
                                  return Center(
                                    child: Text(
                                      "Error: ${snapshot.error}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  );
                                } else {
                                  // Handle initial loading state
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            );
                          }
                          if (state is MsgError) {
                            return const Text(
                              'Something went wrong!',
                              style: TextStyle(color: Colors.red),
                            );
                          }
                          return const SizedBox();
                        })),
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

  // app bar widget
  Widget _appBar() {
    return InkWell(
        onTap: () {
          context.goNamed(RouteNames.viewUserProfileScreen, extra: widget.user);
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Cuser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  //back button
                  IconButton(
                      onPressed: () {
                        context.goNamed(RouteNames.homeScreen);
                      },
                      icon: Icon(Icons.arrow_back, color: APIs.orange)),

                  //user profile picture
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(widget.user.image.toString()),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                  ),
                  //for adding some space
                  const SizedBox(width: 10),

                  //user name & last seen time
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //user name
                      Text(
                          '${list.isNotEmpty ? list[0].name : widget.user.name}',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),

                      //for adding some space
                      const SizedBox(height: 2),

                      //last seen time of user
                      Text(
                          list.isNotEmpty
                              ? list[0].isOnline!
                                  ? 'Online'
                                  : MyDateUtil.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive!)
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.lastActive!),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white)),
                    ],
                  )
                ],
              );
            }));
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
                      icon: Icon(Icons.emoji_emotions,
                          color: APIs.orange, size: 26)),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: APIs.orange),
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
                          _msgBloc
                              .add(SendImgMessage(widget.user, File(i.path)));

                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                      icon: Icon(Icons.image, color: APIs.orange, size: 26)),
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

                          _msgBloc.add(
                              SendImgMessage(widget.user, File(image.path)));

                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                      icon: Icon(Icons.camera_alt_rounded,
                          color: APIs.orange, size: 26)),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                _msgBloc.add(SendMessage(
                    widget.user, _textController.text, MsgType.text));
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: APIs.yellow,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
