import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Navigaitions/routes_names.dart';
import 'package:chatters_2/Support/data_utils.dart';
import 'package:chatters_2/Widgets/profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatterCard extends StatefulWidget {
  final Cuser user;
  const ChatterCard({super.key, required this.user});

  @override
  State<ChatterCard> createState() => _ChatterCardState();
}

class _ChatterCardState extends State<ChatterCard> {
  Messages? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      //    color: Colors.lightBlue[100],
      child: InkWell(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: [
                      Center(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 255, 166, 166)),
                                shape: MaterialStateProperty.all(
                                    const CircleBorder())),
                            onPressed: () {
                              APIs.deleteChatTile(widget.user.id);
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.delete_forever_sharp,
                              color: Color.fromARGB(255, 255, 17, 0),
                              size: 50.0,
                            )),
                      )
                    ],
                  );
                });
          },
          onTap: () {
            context.goNamed(RouteNames.chatterScreen, extra: widget.user);
          },
          child: StreamBuilder(
            //get latest message
            stream: APIs.getLastMessages(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list = data
                      ?.map((doc) =>
                          Messages.fromJson(doc.data() as Map<String, dynamic>))
                      .toList() ??
                  [];
              if (list.isNotEmpty) {
                _message = list[0];
              }
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                        colors: [APIs.purple, Colors.pink, APIs.purple])),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ProfileDialog(user: widget.user),
                      );
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors
                              .white54, // Adjust the color of the ring to black
                          width: 2.0, // Adjust the width of the ring
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 28.0,
                        backgroundImage: APIs.buildNetworkImage(widget.user),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  title: Text(
                    widget.user.name!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: APIs.yellow),
                  ),
                  subtitle: Text(
                    _message != null
                        ? _message!.type == MsgType.image 
                            ? '📷 Image' 
                            : _message!.type == MsgType.image ?
                            '🎤 Voice' :
                            _message!.msg 
                        : widget.user.about!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey[200],
                      fontSize: 14.0,
                    ),
                  ),
                  trailing: _message == null
                      ? null // No messages
                      : _message!.read.isEmpty &&
                              _message?.fromId != APIs.user.uid
                          ? Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Text(
                              MyDateUtil.getLastMessageTime(
                                context: context,
                                time: _message!.sent,
                              ),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12.0,
                              ),
                            ),
                  tileColor: Colors.transparent,
                ),
              );
            },
          )),
    );
  }
}
