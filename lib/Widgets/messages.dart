

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Support/data_utils.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.messages});

  final Messages messages;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    //final fromId = .trim().toLowerCase();
    // print('From ID: $fromId');
    return widget.messages.fromId == APIs.user.uid ? __greenMsg() : __blueMsg();
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
            padding: EdgeInsets.all(widget.messages.type == Type.image
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
            child: widget.messages.type == Type.text
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
            padding: EdgeInsets.all(widget.messages.type == Type.image
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
            child: widget.messages.type == Type.text
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
}