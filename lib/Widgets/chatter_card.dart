import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Core/repository/message_repo.dart';
import 'package:chatters_2/Models/messages.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Screens/chatter_screen.dart';
import 'package:chatters_2/Support/data_utils.dart';
import 'package:chatters_2/Widgets/profile_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatterCard extends StatefulWidget {
  final Cuser user;
  final MsgRepository msgRepository;
  const ChatterCard({super.key, required this.user, required this.msgRepository});

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
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatterScreen(user: widget.user, msgRepository: widget.msgRepository,)));
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
              return ListTile(
                leading: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.1, // Adjust as needed
                  height: MediaQuery.of(context).size.width *
                      0.1, // Adjust as needed

                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(user: widget.user));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.03),
                      child: CachedNetworkImage(
                        width: MediaQuery.sizeOf(context).width * .055,
                        height: MediaQuery.sizeOf(context).height * .055,
                        imageUrl: widget.user.image!,
                        //url empty
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(widget.user.name!),
                subtitle: Text(
                  //show latest message
                  _message != null
                      ? _message!.type == MsgType.image
                          ? 'image'
                          : _message!.msg
                      : widget.user.about!,
                  maxLines: 1,
                ),
                trailing: _message == null
                    ? null //no messages
                    :
                    //show when message unread
                    _message!.read.isEmpty && _message?.fromId != APIs.user.uid
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        :
                        //message read
                        Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black45),
                          ),
              );
            },
          )),
    );
  }
}
