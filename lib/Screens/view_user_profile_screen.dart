import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Navigaitions/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Import the intl package

//view profile screen -- to view profile of user
class ViewProfileScreen extends StatefulWidget {
  final Cuser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //app bar
          appBar: AppBar(
            title: Text(
              widget.user.name!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: APIs.purple,
            leading: IconButton(
              onPressed: () {
                context.goNamed(RouteNames.chatterScreen, extra: widget.user);
              },
              icon: const Icon(Icons.arrow_back),
              color: APIs.orange,
            ),
          ),
          floatingActionButton: //user about
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(widget.user.createdAt!)),
                style: const TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ],
          ),

          //body
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * .03),

                  //user profile picture
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: APIs.buildNetworkImage(widget.user),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                  ),

                  // for adding some space
                  SizedBox(height: MediaQuery.sizeOf(context).height * .03),

                  // user email label
                  Text(widget.user.email!,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16)),

                  // for adding some space
                  SizedBox(height: MediaQuery.sizeOf(context).height * .02),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(widget.user.about!,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
