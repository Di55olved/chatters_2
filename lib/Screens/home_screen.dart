import 'dart:developer';

import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Models/user.dart';
import 'package:chatters_2/Screens/profile_screen.dart';
import 'package:chatters_2/Support/dialogs.dart';
import 'package:chatters_2/Widgets/chatter_card.dart';
import 'package:chatters_2/Widgets/my_assets.dart';
import 'package:chatters_2/bloc/user_bloc/user_bloc.dart';
import 'package:chatters_2/bloc/user_bloc/user_events.dart';
import 'package:chatters_2/bloc/user_bloc/user_states.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;

  const HomeScreen({super.key, required this.userRepository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserBloc _userBloc;
  List<Cuser> _userList = [];
  final List<Cuser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userRepository: widget.userRepository);
    _userBloc.add(const FetchUser());
    APIs.getSelfInfo();

//for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    // APIs.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          //if user presses back button, search unselected and app does not close
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: APIs.purple,
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name, Email, ...'),
                      autofocus: true,
                      style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                      //when search text changes then updated search list
                      onChanged: (val) {
                        //search logic
                        _searchList.clear();

                        for (var i in _userList) {
                          if (i.name!
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email!
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                            setState(() {
                              _searchList;
                            });
                          }
                        }
                      },
                    )
                  : Text(
                      'BrieF Chat',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: APIs.yellow),
                    ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search),
                  color: APIs.orange,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                user: APIs.me,
                                userRepository: widget.userRepository)));
                  },
                  icon: const Icon(Icons.person_2_rounded),
                  color: APIs.orange,
                )
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                backgroundColor: APIs.orange,
                onPressed: () {
                  _addChatUser();
                },
                child: const Icon(Icons.add_comment_rounded),
              ),
            ),
            body: Stack(
              children: [
                // Background image with low alpha opacity
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.2, 
                    child: MyAssets.transLogo,
                  ),
                ),
                BlocBuilder(
                  bloc: _userBloc,
                  builder: (_, UserState state) {
                    if (state is UserEmpty) {
                      return const Center(child: Text('Empty state'));
                    }
                    if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is UserLoaded) {
                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: state.user(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _userList = snapshot.data!.docs
                                .map((doc) => Cuser.fromJson(doc.data()))
                                .toList();

                            if (_userList.isEmpty) {
                              // Handle empty list
                              return const Center(
                                child: Text(
                                  "No Users Available",
                                  style: TextStyle(fontSize: 30),
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: _isSearching
                                  ? _searchList.length
                                  : _userList.length,
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .01,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatterCard(
                                  user: _isSearching
                                      ? _searchList[index]
                                      : _userList[index],
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
                    if (state is UserError) {
                      return const Text(
                        'Something went wrong!',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                    return const SizedBox();
                  },
                )
              ],
            )),
      ),
    );
  }

  void _addChatUser() {
    String email = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //title
            title: Row(
              children: [
                Icon(
                  Icons.person_2_outlined,
                  color: APIs.orange,
                  size: 28,
                ),
                const Text(' Add User')
              ],
            ),

            //content
            content: TextFormField(
              maxLines: null,
              onChanged: (value) => email = value,
              decoration: InputDecoration(
                  hintText: 'Email ID',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: APIs.orange,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),

            //actions
            actions: [
              //cancel button
              MaterialButton(
                  onPressed: () {
                    //hide alert dialog
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: APIs.orange, fontSize: 16),
                  )),

              //update button
              MaterialButton(
                  onPressed: () async {
                    //hide alert dialog
                    Navigator.pop(context);
                    if (email.isNotEmpty) {
                      await APIs.addChatterExists(email).then((value) {
                        if (!value) {
                          Dialogs.showSnackBar(context, "User does not exist");
                        }
                      });
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: APIs.orange, fontSize: 16),
                  ))
            ],
          );
        });
  }
}
