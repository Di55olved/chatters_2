// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Navigaitions/routes_names.dart';
import 'package:chatters_2/Support/dialogs.dart';
import 'package:flutter/material.dart';

import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Support/data_utils.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.messages, required this.user});

  final Messages messages;
  final Cuser user;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool check = widget.messages.fromId == APIs.user.uid;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(check);
      },
      child: check ? __greenMsg() : __blueMsg(),
    );
  }

  Widget __blueMsg() {
    //update last read message if sender and receiver are different
    if (widget.messages.read.isNotEmpty) {
      // Update the read status only if it's empty or null
      APIs.updateMessageReadStatus(widget.messages);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.messages.type == MsgType.image
                ? MediaQuery.sizeOf(context).width * .03
                : MediaQuery.sizeOf(context).width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .04,
                vertical: MediaQuery.sizeOf(context).height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.messages.type == MsgType.text
                ?
                //show text
                Text(
                    widget.messages.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.messages.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),

        //message time
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.sizeOf(context).width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.messages.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget __greenMsg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            //for adding some space
            SizedBox(width: MediaQuery.sizeOf(context).width * .04),

            //double tick blue icon for message read
            Icon(Icons.done_all_rounded,
                color:
                    widget.messages.read.isNotEmpty ? Colors.blue : Colors.grey,
                size: 20),
            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.messages.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.messages.type == MsgType.image
                ? MediaQuery.sizeOf(context).width * .03
                : MediaQuery.sizeOf(context).width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .04,
                vertical: MediaQuery.sizeOf(context).height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: widget.messages.type == MsgType.text
                ?
                //show text
                expandableMessageCard(widget.messages.msg)

                // Text(
                //     widget.messages.msg,
                //     style: const TextStyle(fontSize: 15, color: Colors.black87),
                //   )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.messages.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget expandableMessageCard(String messageText) {
    final maxLengthToShow = 200;

    if (messageText.length > maxLengthToShow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            messageText.substring(0, maxLengthToShow) + '...',
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: SingleChildScrollView(
                    child: Text(
                      messageText,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Read More'),
          ),
        ],
      );
    } else {
      return Text(
        messageText,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      );
    }
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.messages.msg;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),

            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

            //title
            title: const Row(
              children: [
                Icon(
                  Icons.message,
                  color: Colors.blue,
                  size: 28,
                ),
                Text(' Update Message')
              ],
            ),

            //content
            content: TextFormField(
              initialValue: updatedMsg,
              maxLines: null,
              onChanged: (value) => updatedMsg = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),

            //actions
            actions: [
              //cancel button
              MaterialButton(
                  onPressed: () async {
                    //hide alert dialog
                    Navigator.of(context).pop();
                    context.goNamed(RouteNames.chatterScreen,
                        extra: widget.user);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  )),

              //update button
              MaterialButton(
                  onPressed: () {
                    //hide alert dialog
                    if (updatedMsg == '') {
                      APIs.deleteMessage(widget.messages);
                      Navigator.of(context).pop();
                      context.goNamed(RouteNames.chatterScreen,
                          extra: widget.user);
                    } else {
                      APIs.updateMessage(widget.messages, updatedMsg);
                      Navigator.of(context).pop();
                      context.goNamed(RouteNames.chatterScreen,
                          extra: widget.user);
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ))
            ],
          );
        });
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).height * .015,
                    horizontal: MediaQuery.sizeOf(context).width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.goNamed(RouteNames.chatterScreen,
                        extra: widget.user);
                  },
                  icon: const Icon(Icons.close)),

              widget.messages.type == MsgType.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.messages.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.of(context).pop();
                          context.goNamed(RouteNames.chatterScreen,
                              extra: widget.user);

                          Dialogs.showSnackBar(context, 'Text Copied!');
                        });
                      })
                  //save Image option
                  : _OptionItem(
                      icon: const Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          // Fetch image URL from Firestore
                          String imageUrl = widget.messages.msg;

                          // Use a network library (e.g., http) to download the image data
                          final response = await http.get(Uri.parse(imageUrl));

                          if (response.statusCode == 200) {
                            // Convert the response body to Uint8List
                            Uint8List uint8List = response.bodyBytes;

                            // Save the image to the gallery
                            await ImageGallerySaver.saveImage(
                              uint8List,
                              isReturnImagePathOfIOS:
                                  true, // Set to true if targeting iOS
                            );

                            Navigator.of(context).pop();
                            context.goNamed(RouteNames.chatterScreen,
                                extra: widget.user);
                          } else {
                            print(
                                'Failed to download image: ${response.statusCode}');
                          }
                        } catch (e) {
                          print('Error While Saving Image: $e');
                        }
                      },
                    ),

              //edit option
              if (widget.messages.type == MsgType.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.of(context).pop();
                      context.goNamed(RouteNames.chatterScreen,
                          extra: widget.user);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.messages).then((value) {
                        //for hiding bottom sheet
                        Navigator.of(context).pop();
                        context.goNamed(RouteNames.chatterScreen,
                            extra: widget.user);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: MediaQuery.sizeOf(context).width * .04,
                indent: MediaQuery.sizeOf(context).width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.messages.sent)}',
                  onTap: () {}),
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          icon,
          Flexible(
              child: Text(
            "    $name",
            style: const TextStyle(
                fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
          ))
        ]),
      ),
    );
  }
}
